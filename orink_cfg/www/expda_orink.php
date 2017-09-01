<?php
  // error_reporting(0);
  require_once 'firebird.php';
  require_once 'converter.php';
  header('Access-Control-Allow-Origin: *');  
  date_default_timezone_set('Europe/Budapest');
  
  function expaMail($fejazon,$param){
    //$param = 'KULDES';
	//email teszteléshez: EML_ELTERES_TESZT
	$output=array();
	exec('expamail.bat EML_ELTERES '.$param.' ORINKMUNKA -P:"'.$fejazon.'"',$output,$return);
	$res = json_encode($output);
	logol('[expamail] '.$res);
  }
  
  function emailteszt($r){
      $azon=1603019;

	  $sql = "SELECT BIZTIP FROM BFEJ WHERE AZON=:azon";
	  $stmt = query_prepare($sql);
	  $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
	  $q = query_exec($stmt);
	  var_dump($q);
	  $biztip = $q[0]['BIZTIP'];
	  $param='KULDES';
	  if ($biztip=='AF15') $param='DEV_KULDES';
	  logol('[kiadellenor lezar] azon:'.$azon.' biztip:'.$biztip);
	  
	  
      $sql = "SELECT FIRST 1 'OKELTERES' OKELTERES  FROM BFEJ";
      $stmt = query_prepare($sql);
      $q = query_exec($stmt);
	  echo $res = response_print($q);
	  Firebird::commit();
	  //email
      foreach ($q as $row) {
		foreach ($row as $k => $v) {
			//$line .= "[[$k=$v]]";
			if ($v=='OKELTERES') expaMail($azon,$param);
		}
	  }

  }
  
  function leftcut ($arg1, $arg2) {
     $arg2 = '/'.$arg2.'/';
     $vissza = preg_split($arg2, $arg1);
     return $vissza;
  }
  
  function logol($szoveg,$css="") {
       //return false;
	   
       $dat=date('y.m.d H:i:s');
	   $datd=date('y.m.d');
	   $dats=str_replace('.','',$datd);
	   
       
       $ip = strip_tags($_SERVER['REMOTE_ADDR']);
       if ($ip=='::1') $ip='127001';
	   $fnev = str_replace('.','',$ip).'_'.$dats.'.html';
	   @mkdir("log", 0700);
       $fnev="log/$fnev";
	   $includecss="";
	   if (!file_exists($fnev)) {
		   $includecss='<link rel="stylesheet" type="text/css" href="../log.css">';
	   }
       $fp = fopen($fnev, 'a');
	   $return=" \r\n";
	   if ($includecss!="") {
		   fwrite($fp, $includecss.$return);
	   }
	   
	   if (stripos($szoveg,'error')!==false) {
		   $szoveg1="<div class=diverror".$css.">";
	   }
	   else {
		   $szoveg1="<div class=divnormal".$css.">";
	   }
       $szoveg1.="<span class='header_text'>".$dat." $ip</span>:";
       
       fwrite($fp, $szoveg1.'<pre>'.$szoveg.'</pre>'.$return);
       //fwrite($fp, '*****'.$return);
	   fwrite($fp, '</div>'.$return);
       fclose($fp);
  }
	
  function parsing($array) {
		return "('".implode("', '", $array)."')";
  }
    
  $command = '';
  if (isset($_REQUEST['command'])) $command=$_REQUEST['command'];
  $ix = 1;
  $par = array();
  while (isset($_REQUEST['p'.$ix])) {
	$par[]=urldecode($_REQUEST['p'.$ix]);
	$ix++;
  }

   if ($command==''){
       foreach ($_REQUEST as $p => $v){ 
            $command = $v;
            break;
       }
   }
   // print_r($_POST);
  if (function_exists($command)) {
   logol('start: '.$command.' params:'.json_encode($_REQUEST),'_header')  ;
   try {
     call_user_func($command,$_REQUEST);
   } finally {
     logol('finish: '.$command,'_footer')  ;
   }

  }
  else if ($command=='') echo "welcome, no command";
  else {logol('error: function not exists:'.$command. ' params: '.json_encode($_REQUEST));echo "'$command' function doesn't exist";}
  

  function query_prepare($sql){
     logol($sql);
     
     $arr = Firebird::prepare($sql,'orink');
     if (!$arr) {
         $errors = Firebird::errorInfo();
         logol('error:'.$errors[2]);
     }

     return $arr;
  }
  function query_exec($stmt){
        $stmt->execute();
        if($stmt->errorCode() == 0) {
        } else {
            $errors = $stmt->errorInfo();
            logol('error:'.$errors[2]);
        }
		return $stmt->fetchAll(PDO::FETCH_ASSOC);
  }
  function query_print($stmt){ 
	$q = query_exec($stmt);
	$res = response_print($q);
	return $res;	
  }
  function response_print($array){ 
    $res="";
	foreach ($array as $row) {
		$line = '';
		foreach ($row as $k => $v) {
			$line .= "[[$k=$v]]";
		}
		$res .= $line.chr(13).chr(10);
	}
    $utf = utf8_encode($res);
    logol($utf);
	return $utf;	
  }    
  /* altalanos */
  function applog($r){
      $kezelo=$r['p1'];
      $logtip=$r['p2'];
      $logtext=$r['p3'];
      logol('['.$logtip.']' . 'kezelo:' .$kezelo.' log:'.$logtext);
      echo "ok";
  }
  function ean_check($r){
      $sql="SELECT CIKK,CIKKNEV,RESULT FROM ANDROID_EAN_CHECK(:ean)";
      $stmt = query_prepare($sql);
      $ean=trim($r['p1']);
	  $stmt->bindParam(':ean', $ean, PDO::PARAM_STR);
	  echo query_print($stmt);
  }  

  function hkod_check($r){
      $sql="SELECT RESULT FROM ANDROID_HKOD_CHECK(:hkod,:kulso)";
      $stmt = query_prepare($sql);
      $hkod=trim($r['p1']);
      $kulso=trim($r['p2']);
	  $stmt->bindParam(':hkod', $hkod, PDO::PARAM_STR);
      $stmt->bindParam(':kulso', $kulso, PDO::PARAM_STR);
	  echo query_print($stmt);
  }    
  function cikkval_open($r){
      $sql="SELECT KOD,NEV||'|@@style:listtitle' NEV FROM ANDROID_CIKK_KERES(:betuz,30,:filterstr)";
      $stmt = query_prepare($sql);
      $betuz=trim($r['p1']);
      $betuz=str_replace('%20',' ',$betuz);
      $betuz=utf8_decode($betuz);
      
      $filterstr = trim($r['p2']);
      
	  $stmt->bindParam(':betuz', $betuz, PDO::PARAM_STR);
	  $stmt->bindParam(':filterstr', $filterstr, PDO::PARAM_STR);
	  echo query_print($stmt);      
  }
  function meretment($r){
      $sql="SELECT RESULT,RESULTTEXT FROM ANDROID_MERET_MENT(:cikk,:meret,:suly,:login)";
      $stmt = query_prepare($sql);
      $cikk=trim($r['p1']);
      $meret=trim($r['p2']);
      $suly=trim($r['p3']);
      $login=trim($r['p4']);
      if ($cikk=='.') $cikk='';
      if ($meret=='.') $meret='';
      if ($suly=='.') $suly='';
	  $stmt->bindParam(':cikk', $cikk, PDO::PARAM_STR);
	  $stmt->bindParam(':meret', $meret, PDO::PARAM_STR);
	  $stmt->bindParam(':suly', $suly, PDO::PARAM_STR);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
	  echo query_print($stmt);
      Firebird::commit();
  }      
  /* altalanos eddig*/
  /* login */
  function login_check($r){
        $sql="SELECT RESULTTEXT FROM ANDROID_LOGIN_CHECK(:login)";
        $stmt = query_prepare($sql);
        
		$login=trim($r['p1']);
		$stmt->bindParam(':login', $login, PDO::PARAM_STR);
		echo query_print($stmt);
  }
  /* login eddig */
  /* kiadas */
  function kiadas_mibizlist($r){
      $sql="SELECT CEGNEV||'|@@style:listtitle;listtitledone' CEGNEV,";
      $sql.="mibiz||'|@@style:listtitle;listtitledone' MIBIZ,";
      $sql.="'Szállmód: '||COALESCE(SZALLMOD,'')||'|@@style:listdetails' SZALLMOD,";
      $sql.="'Súly: '||CAST(SULY AS NUMERIC(10,2))||'|@@style:listdetails' SULY,";
      $sql.="'Térf: '||CAST(TERFOGAT AS NUMERIC(10,2))||'|@@style:listdetails' TERFOGAT,";      
      $sql.="'Dev: '||DEVIZA||'|@@style:listdetails' DEVIZA,";            
      $sql.="'Sorok: '||SORDB||'|@@style:listdetails' SORDB,AZON";            
      $sql.="      FROM ANDROID_KIADAS_MIBIZLIST(:login,:kulso,:biztip)";
      $stmt = query_prepare($sql);
      $login=trim($r['p1']);
      $kulso=trim($r['p2']);
      if (isset($r['p3'])) $biztip=trim($r['p3']);
      else $biztip='';
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':kulso', $kulso, PDO::PARAM_STR);      
      $stmt->bindParam(':biztip', $biztip, PDO::PARAM_STR);      
	  echo query_print($stmt);
  }
  function kiadas_init($r){
      $sql="SELECT RESULT,RESULTTEXT FROM ANDROID_KIADAS_INIT(:azon,:login,:kulso)";
      $stmt = query_prepare($sql);
      $azon=trim($r['p1']);
      $login=trim($r['p2']);
      $kulso=trim($r['p3']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
      $stmt->bindParam(':kulso', $kulso, PDO::PARAM_STR);
	  echo query_print($stmt);
      Firebird::commit();
  }
  function kiadas_kovsor($r){
      $sql="SELECT CIKK, CIKKNEV, HKOD, cast(DRB as integer) DRB, cast(DRB2 as integer) DRB2, SULY,TERFOGAT,MEGYS,RESULT FROM ANDROID_KIADAS_LEPTET(:azon,:hkod,:cikk,:irany,:login)";
      $stmt = query_prepare($sql);
      $azon=trim($r['p1']);
      $hkod=trim($r['p2']);
      $cikk=trim($r['p3']);
      $irany=trim($r['p4']);
      $login=trim($r['p5']);
      
      if ($cikk=='.') $cikk='';
      if ($hkod=='.') $hkod='';
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
      $stmt->bindParam(':hkod', $hkod, PDO::PARAM_STR);
      $stmt->bindParam(':cikk', $cikk, PDO::PARAM_STR);
      $stmt->bindParam(':irany', $irany, PDO::PARAM_STR);      
	  echo query_print($stmt);
  }
  
  function kiadas_mentes($r){
      $sql = "SELECT RESULTTEXT,RESULT FROM ANDROID_KIADAS_MENTES(:azon, :cikk, :ean, :hkod,:drb2,:hiany,:hiany_oka, :login, :kulso)";
      $stmt = query_prepare($sql);
      
      $azon=trim($r['p1']);
      $cikk=trim($r['p2']);
      $ean=trim($r['p3']);
      $hkod=trim($r['p4']);
      $drb2=trim($r['p5']);
      $hiany=trim($r['p6']);
      $hiany_oka=trim($r['p7']);
      $login=trim($r['p8']);
      $kulso=trim($r['p9']);
      if ($hiany_oka=='.') $hiany_oka='';
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
      $stmt->bindParam(':cikk', $cikk, PDO::PARAM_STR);
      $stmt->bindParam(':hkod', $hkod, PDO::PARAM_STR);
      $stmt->bindParam(':drb2', $drb2, PDO::PARAM_STR);
      $stmt->bindParam(':hiany', $hiany, PDO::PARAM_STR);
      $stmt->bindParam(':hiany_oka', $hiany_oka, PDO::PARAM_STR);
      $stmt->bindParam(':ean', $ean, PDO::PARAM_STR);
      $stmt->bindParam(':kulso', $kulso, PDO::PARAM_STR);
	  echo query_print($stmt);      
      Firebird::commit();
  }


  function kiadas_cikklist($r){
      $sql="SELECT CIKK, CIKKNEV||case ";
      $sql.="  when (abs(drb) = drb2 and coalesce(stat3,'')<>'H') then '|@@style:listtitle;listtitledone' ";
      $sql.="  when (abs(drb) = drb2 and coalesce(stat3,'')='H') then '|@@style:listtitle;listtitlemiss' ";
      $sql.= " when (drb2=0) then '|@@style:listtitle;listtitlewait' ";
      $sql.= " when (abs(drb) > drb2 and drb2>0) then '|@@style:listtitle;listtitlework' end CIKKNEV,";
          
      $sql.= " 'Helykód:'||HKOD||case ";
      $sql.="  when (abs(drb) = drb2 and coalesce(stat3,'')<>'H') then '|@@style:listtitle;listtitledone' ";
      $sql.="  when (abs(drb) = drb2 and coalesce(stat3,'')='H') then '|@@style:listtitle;listtitlemiss' ";
      $sql.= " when (drb2=0) then '|@@style:listtitle;listtitlewait' ";
      $sql.= " when (abs(drb) > drb2 and drb2>0) then '|@@style:listtitle;listtitlework' end HKOD,";

      $sql.= " 'Kiszedendõ: '||cast(DRB as integer)||case ";
      $sql.="  when (abs(drb) = drb2 and coalesce(stat3,'')<>'H') then '|@@style:listtitle;listtitledone' ";
      $sql.="  when (abs(drb) = drb2 and coalesce(stat3,'')='H') then '|@@style:listtitle;listtitlemiss' ";
      $sql.= " when (drb2=0) then '|@@style:listtitle;listtitlewait' ";
      $sql.= " when (abs(drb) > drb2 and drb2>0) then '|@@style:listtitle;listtitlework' end DRB,";
      
      $sql.= " 'Kiszedve: '||cast(DRB2 as integer)||case ";
      $sql.="  when (abs(drb) = drb2 and coalesce(stat3,'')<>'H') then '|@@style:listtitle;listtitledone' ";
      $sql.="  when (abs(drb) = drb2 and coalesce(stat3,'')='H') then '|@@style:listtitle;listtitlemiss' ";
      $sql.= " when (drb2=0) then '|@@style:listtitle;listtitlewait' ";
      $sql.= " when (abs(drb) > drb2 and drb2>0) then '|@@style:listtitle;listtitlework' end DRB2";      
      
      $sql.= "  FROM ANDROID_KIADAS_REVIEW(:login,:azon)";
      $stmt = query_prepare($sql);
      $login=trim($r['p1']);
      $azon=trim($r['p2']);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
	  echo query_print($stmt);
  }

  function kiadas_kesobb($r){
      $sql="SELECT RESULT,RESULTTEXT ";      
      $sql.= "  FROM ANDROID_KIADAS_KESOBBFOLYT(:login,:azon)";
      $stmt = query_prepare($sql);
      $login=trim($r['p1']);
      $azon=trim($r['p2']);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
	  echo query_print($stmt);
      Firebird::commit();
  }
 

  function kiadas_lezaras($r){
      $sql = "SELECT RESULTTEXT FROM ANDROID_KIADAS_LEZAR(:login,:azon)";
      $stmt = query_prepare($sql);
      
      $azon=trim($r['p1']);
      $login=trim($r['p2']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
	  echo query_print($stmt);      
      Firebird::commit();
  }
  /* kiadas eddig */
  /* beerkezes */

  function beerk_ceglist($r){
      $sql="SELECT NEV||'|@@style:listtitle' NEV,RENTIP||'|@@style:listtitle' RENTIP,AZON||'|@@style:listhidden' AZON FROM ANDROID_BEERK_CEGLIST";
      $stmt = query_prepare($sql);
	  echo query_print($stmt);
  }    
  
  function beerk_bizkeres($r){
      $sql = "SELECT AZON,MIBIZ FROM ANDROID_BEERK_BIZKERES(:ceg,:login,:kulso)";
      $stmt = query_prepare($sql);
      
      $ceg=trim($r['p1']);
      $login=trim($r['p2']);
      $kulso=trim($r['p3']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':kulso', $kulso, PDO::PARAM_STR);
      $stmt->bindParam(':ceg', $ceg, PDO::PARAM_STR);
	  echo query_print($stmt);      
  }  
  function beerk_eankeres($r){
      $sql = "SELECT CIKK,CIKKNEV, DRB, DRB2, DRB3, MERET,SULY, RESULT FROM ANDROID_BEERK_EANKERES(:ceg,:ean,:cikod,:login,:kulso,:rentip)";
      $stmt = query_prepare($sql);
      
      $ceg=trim($r['p1']);
      $ean=trim($r['p2']);
      $cikod=trim($r['p3']);
      $login=trim($r['p4']);
      $kulso=trim($r['p5']);
      $rentip=trim($r['p6']);
      if ($rentip=='.') $rentip='';
      if ($ean=='.') $ean='';
      if ($cikod=='.') $cikod='';
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':ean', $ean, PDO::PARAM_STR);
      $stmt->bindParam(':cikod', $cikod, PDO::PARAM_STR);  
      $stmt->bindParam(':ceg', $ceg, PDO::PARAM_STR);
      $stmt->bindParam(':kulso', $kulso, PDO::PARAM_STR);
      $stmt->bindParam(':rentip', $rentip, PDO::PARAM_STR);      
	  echo query_print($stmt);      
  }  
  function beerk_ment($r){
      $sql = "SELECT RESULT,RESULTTEXT,MIBIZ,AZON FROM ANDROID_BEERK_MENTES(:azon, :ceg, :cikk, :ean, :drb, :login, :kulso)";
      $stmt = query_prepare($sql);
      
      $azon=trim($r['p1']);
      $ceg=trim($r['p2']);
      $cikk=trim($r['p3']);
      $ean=trim($r['p4']);
      $drb=trim($r['p5']);
      $login=trim($r['p6']);
      $kulso=trim($r['p7']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
      $stmt->bindParam(':drb', $drb, PDO::PARAM_STR);
      $stmt->bindParam(':ceg', $ceg, PDO::PARAM_STR);
      $stmt->bindParam(':ean', $ean, PDO::PARAM_STR);
      $stmt->bindParam(':cikk', $cikk, PDO::PARAM_STR);
      $stmt->bindParam(':kulso', $kulso, PDO::PARAM_STR);
	  echo query_print($stmt);      
      Firebird::commit();
  }
  
  function beerk_cikklist($r){
      $sql="SELECT CIKK, CIKKNEV||'|@@style:listtitle;listtitledone' AS CIKKNEV,";
      $sql.= " EAN||'|@@style:listdetails;listtitledone' AS EAN,";
      $sql.= " 'Érkezett: '||cast(DRB as integer)||'|@@style:listdetails;listtitledone' AS DRB";
      $sql.= "  FROM ANDROID_BEERK_REVIEW(:login,:azon)";
      $stmt = query_prepare($sql);
      $login=trim($r['p1']);
      $azon=trim($r['p2']);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
	  echo query_print($stmt);
  }  
  function beerk_kesobbfolyt($r){
      $sql = "SELECT RESULT,RESULTTEXT FROM ANDROID_BEERK_KESOBBFOLYT(:login, :azon)";
      $stmt = query_prepare($sql);
      
      $azon=trim($r['p1']);
      $login=trim($r['p2']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
	  echo query_print($stmt);      
      Firebird::commit();
  }
  
  function beerk_lezaras($r){
      $sql = "SELECT RESULTTEXT FROM ANDROID_BEERK_LEZAR(:login,:azon,:rentip)";
      $stmt = query_prepare($sql);
      
      $login=trim($r['p1']);
      $azon=trim($r['p2']);
      $rentip=trim($r['p3']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
      $stmt->bindParam(':rentip', $rentip, PDO::PARAM_STR);
	  echo query_print($stmt);      
      Firebird::commit();
  }  
  /* bevet eddig */
  /* leltar innen */
  function leltar_mibizlist($r){
      $sql="SELECT AZON,MIBIZ FROM ANDROID_LELTAR_MIBIZLIST(:login,:kulso)";
      $stmt = query_prepare($sql);
      $login=trim($r['p1']);
      $kulso=trim($r['p2']);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':kulso', $kulso, PDO::PARAM_STR);
	  echo query_print($stmt);
  }  

  function leltar_init($r){
      $sql="SELECT RESULT,RESULTTEXT FROM ANDROID_LELTAR_INIT(:azon,:login,:kulso)";
      $stmt = query_prepare($sql);
      $azon=trim($r['p1']);
      $login=trim($r['p2']);
      $kulso=trim($r['p3']);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
      $stmt->bindParam(':kulso', $kulso, PDO::PARAM_STR);
	  echo query_print($stmt);
      Firebird::commit();
  }
  function leltar_ean_check($r){
      $sql="SELECT CIKK,CIKKNEV,DRB2,RESULT FROM ANDROID_LELTAR_EANKERES(:azon, :hkod, :ean, :cikk)";
      $stmt = query_prepare($sql);
      $ean=trim($r['p1']);
      $cikk=trim($r['p2']);      
      $azon=trim($r['p3']);      
      $hkod=trim($r['p4']);      
      if ($ean=='.') $ean='';
      if ($cikk=='.') $cikk='';
	  $stmt->bindParam(':ean', $ean, PDO::PARAM_STR);
	  $stmt->bindParam(':cikk', $cikk, PDO::PARAM_STR);
	  $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
	  $stmt->bindParam(':hkod', $hkod, PDO::PARAM_STR);
	  echo query_print($stmt);
  }  
  

  function leltar_ment($r){
      $sql = "SELECT RESULT,RESULTTEXT,MIBIZ,AZON FROM ANDROID_LELTAR_MENTES(:azon, :hkod, :cikk, :ean, :drb, :login, :kulso)";
      $stmt = query_prepare($sql);
      
      $azon=trim($r['p1']);
      $hkod=trim($r['p2']);
      $cikk=trim($r['p3']);
      $ean=trim($r['p4']);
      $drb=trim($r['p5']);
      $login=trim($r['p6']);
      $kulso=trim($r['p7']);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
      $stmt->bindParam(':drb', $drb, PDO::PARAM_STR);
      $stmt->bindParam(':hkod', $hkod, PDO::PARAM_STR);
      $stmt->bindParam(':ean', $ean, PDO::PARAM_STR);
      $stmt->bindParam(':cikk', $cikk, PDO::PARAM_STR);
      $stmt->bindParam(':kulso', $kulso, PDO::PARAM_STR);
	  echo query_print($stmt);      
      Firebird::commit();
  }
  
  function leltar_cikklist($r){
      $sql="SELECT CIKKNEV||'|@@style:listtitle;listtitledone' CIKKNEV, ";
      $sql.= " EAN||'|@@style:listdetails;listtitledone' EAN, ";
      $sql.= " HKOD||'|@@style:listdetails;listtitledone' HKOD, ";      
      $sql.= " 'Összesen: '||cast(DRB as integer)||'|@@style:listdetails;listtitledone' DRB ";
      $sql.= " FROM ANDROID_LELTAR_REVIEW(:login,:azon)";
      $stmt = query_prepare($sql);
      $login=trim($r['p1']);
      $azon=trim($r['p2']);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
	  echo query_print($stmt);
  }    
  
  function leltar_kesobbfolyt($r){
      $sql = "SELECT RESULT,RESULTTEXT FROM ANDROID_LELTAR_KESOBBFOLYT(:login, :azon)";
      $stmt = query_prepare($sql);
      
      $azon=trim($r['p1']);
      $login=trim($r['p2']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
	  echo query_print($stmt);      
      Firebird::commit();
  }
  
  function leltar_lezaras($r){
      $sql = "SELECT RESULT,RESULTTEXT FROM ANDROID_LELTAR_LEZAR(:login, :azon)";
      $stmt = query_prepare($sql);
      
      $azon=trim($r['p1']);
      $login=trim($r['p2']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
	  echo query_print($stmt);      
      Firebird::commit();
  }
  
/* leltar eddig */
/* hkod rendezés*/
  function hkod_init($r){
      $sql = "SELECT AZON,MIBIZ FROM ANDROID_HKODRA_INIT(:login,:kulso)";
      $stmt = query_prepare($sql);
      $login=trim($r['p1']);
      $kulso=trim($r['p2']);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':kulso', $kulso, PDO::PARAM_STR);
	  echo query_print($stmt);      
  }
  function hkod_cikkhkklt($r){
      $sql = "SELECT ODRB - FDRB AS MAXKIDRB FROM ANDROID_HKODRA_CIKKHKKLT(:hkod, :cikk, :kulso)";
      $stmt = query_prepare($sql);
      
      $hkod=trim($r['p1']);
      $cikk=trim($r['p2']);
      $kulso=trim($r['p3']);
      
	  $stmt->bindParam(':hkod', $hkod, PDO::PARAM_STR);
      $stmt->bindParam(':cikk', $cikk, PDO::PARAM_STR);
      $stmt->bindParam(':kulso', $kulso, PDO::PARAM_STR);
	  echo query_print($stmt);      
  }
  function hkod_hkklt($r){
      $sql = "SELECT CIKKNEV||'|@@style:labeldefault' CIKKNEV,DRB||'|@@style:labeldefault' DRB FROM ANDROID_HKODRA_HKKLT(:hkod,:kulso)";
      $stmt = query_prepare($sql);
      if (isset($r['p1'])) $hkod=trim($r['p1']);
      else $hkod='';
      $kulso=trim($r['p2']);
      
	  $stmt->bindParam(':hkod', $hkod, PDO::PARAM_STR);
      $stmt->bindParam(':kulso', $kulso, PDO::PARAM_STR);
	  echo query_print($stmt);      
  }  
  function hkod_cikkklt($r){
      $sql = "SELECT HKOD||'|@@style:labeldefault' HKOD,DRB||'|@@style:labeldefault' DRB FROM ANDROID_HKODRA_CIKKKLT(:cikk,:kulso)";
      $stmt = query_prepare($sql);
      if (isset($r['p1'])) $cikk=trim($r['p1']);
      else $cikk='';
      $kulso=trim($r['p2']);
      
	  $stmt->bindParam(':cikk', $cikk, PDO::PARAM_STR);
      $stmt->bindParam(':kulso', $kulso, PDO::PARAM_STR);
	  echo query_print($stmt);      
  }    
  function hkod_kocsiklt($r){
      $sql = "SELECT DRB FROM ANDROID_HKODRA_KOCSIKLT(:azon,:cikk)";
      $stmt = query_prepare($sql);
      $azon=trim($r['p1']);
      $cikk=trim($r['p2']);
      
	  $stmt->bindParam(':cikk', $cikk, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
	  echo query_print($stmt);      
  }
  function hkod_ment($r){
      $sql = "SELECT RESULT,'' RESULTTEXT,MIBIZ,AZON FROM ANDROID_HKODRA_MENTES(:azon, :hkod, :cikk, :ean, :drb, :login,:kulso)";
      $stmt = query_prepare($sql);
      
      $azon=trim($r['p1']);
      $hkod=trim($r['p2']);
      $cikk=trim($r['p3']);
      $ean=trim($r['p4']);
      $drb=trim($r['p5']);
      $login=trim($r['p6']);
      $kulso=trim($r['p7']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
      $stmt->bindParam(':drb', $drb, PDO::PARAM_STR);
      $stmt->bindParam(':hkod', $hkod, PDO::PARAM_STR);
      $stmt->bindParam(':ean', $ean, PDO::PARAM_STR);
      $stmt->bindParam(':cikk', $cikk, PDO::PARAM_STR);
      $stmt->bindParam(':kulso', $kulso, PDO::PARAM_STR);
	  echo query_print($stmt);      
      Firebird::commit();
  }
  function hkod_cikklist($r){
      $sql="SELECT trim(CIKKNEV||'|@@style:listtitle;listtitlewait') CIKKNEVR,";
      $sql.= " trim('Helykód:'||HKOD||'|@@style:listtitle;listtitlewait') HKODR, ";
      $sql.= " trim('Mennyiség:'||cast(DRB as integer)||'|@@style:listtitle;listtitlewait') DRBR ";
      $sql.= "  FROM ANDROID_HKODRA_REVIEW(:login,:azon)";
      $stmt = query_prepare($sql);
      $login=trim($r['p1']);
      $azon=trim($r['p2']);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
	  echo query_print($stmt);
  }
  
  function hkod_lezaras($r){
      $sql = "SELECT RESULT,RESULTTEXT FROM ANDROID_HKODRA_KILEP(:login, :azon)";
      $stmt = query_prepare($sql);
      
      $azon=trim($r['p1']);
      $login=trim($r['p2']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
	  echo query_print($stmt);      
      Firebird::commit();
  }
/* hkod rendezés eddig */
/* spot hkod leltar */    
  function spothkod_check($r){
      $sql="SELECT * FROM ANDROID_SPOTHKOD_HKODCHECK(:hkod,:login,:kulso)";
      $stmt = query_prepare($sql);
      $hkod=trim($r['p1']);
      $login=trim($r['p2']);
      $kulso=trim($r['p3']);
	  $stmt->bindParam(':hkod', $hkod, PDO::PARAM_STR);
      $stmt->bindParam(':kulso', $kulso, PDO::PARAM_STR);
      $stmt->bindParam(':login', $login, PDO::PARAM_STR);
	  echo query_print($stmt);
      Firebird::commit();
  }    
  function spothkod_ment($r){
      $sql = "SELECT RESULT,RESULTTEXT FROM ANDROID_SPOTHKOD_MENTES(:azon, :cikk, :drb, :login,:kulso)";
      $stmt = query_prepare($sql);
      
      $azon=trim($r['p1']);
      $hkod=trim($r['p2']);//nem kell
      $cikk=trim($r['p3']);
      $ean=trim($r['p4']);//nem kell
      $drb=trim($r['p5']);
      $login=trim($r['p6']);
      $kulso=trim($r['p7']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
      $stmt->bindParam(':drb', $drb, PDO::PARAM_STR);
      //$stmt->bindParam(':hkod', $hkod, PDO::PARAM_STR);
      //$stmt->bindParam(':ean', $ean, PDO::PARAM_STR);
      $stmt->bindParam(':cikk', $cikk, PDO::PARAM_STR);
      $stmt->bindParam(':kulso', $kulso, PDO::PARAM_STR);
	  echo query_print($stmt);      
      Firebird::commit();
  }
  function spothkod_cikklist($r){
      $sql="SELECT CIKK, CIKKNEV||'|@@style:listtitle;listtitledone' AS CIKKNEV,";
      $sql.= " 'Számolt: '||cast(DRB as integer)||'|@@style:listdetails;listtitledone' AS DRB,";
      $sql.= " 'Rendszerben: '||cast(DRB2 as integer)||'|@@style:listdetails;listtitledone' AS DRB2";      
      $sql.= "  FROM ANDROID_SPOTHKOD_REVIEW(:azon,:login)";
      $stmt = query_prepare($sql);
      $login=trim($r['p1']);
      $azon=trim($r['p2']);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
	  echo query_print($stmt);
  }    
  function spothkod_lezaras($r){
      $sql = "SELECT RESULT,RESULTTEXT FROM ANDROID_SPOTHKOD_LEZAR(:azon, :login, :kulso)";
      $stmt = query_prepare($sql);
      
      $azon=trim($r['p1']);
      $login=trim($r['p2']);
      $kulso=trim($r['p3']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
      $stmt->bindParam(':kulso', $kulso, PDO::PARAM_STR);
	  echo query_print($stmt);      
      Firebird::commit();
  }/* spot hkod leltar eddig */
  /* kiadas ellenor */
  function ellenor_mibizlist($r){
      $sql="SELECT CEGNEV||'|@@style:listtitle;listtitledone' CEGNEV,";
      $sql.="mibiz||'|@@style:listtitle;listtitledone' MIBIZ,";
      $sql.="'Mozgás: '||MOZGAS||'|@@style:listdetails' MOZGAS,";
      $sql.="'Sorok: '||SORDB||'|@@style:listdetails' SORDB,AZON";            
      $sql.="      FROM ANDROID_KIADELLENOR_MIBIZLIST(:login,:kulso)";
      $stmt = query_prepare($sql);
      $login=trim($r['p1']);
      $kulso=trim($r['p2']);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':kulso', $kulso, PDO::PARAM_STR);      
	  echo query_print($stmt);
  }
  function ellenor_init($r){
      $sql="SELECT RESULT,RESULTTEXT FROM ANDROID_KIADELLENOR_INIT(:azon,:login,:kulso)";
      $stmt = query_prepare($sql);
      $azon=trim($r['p1']);
      $login=trim($r['p2']);
      $kulso=trim($r['p3']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
      $stmt->bindParam(':kulso', $kulso, PDO::PARAM_STR);
	  echo query_print($stmt);
      Firebird::commit();
  }
  function ellenor_eankeres($r){
      $sql = "SELECT CIKK,CIKKNEV, DRB, DRB2, MEGYS, RESULT FROM ANDROID_KIADELLENOR_EANKERES(:azon,:ean,:cikod,:login,:kulso)";
      $stmt = query_prepare($sql);
      
      $azon=trim($r['p1']);
      $ean=trim($r['p2']);
      $cikod=trim($r['p3']);
      $login=trim($r['p4']);
      $kulso=trim($r['p5']);
      if ($ean=='.') $ean='';
      if ($cikod=='.') $cikod='';
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':ean', $ean, PDO::PARAM_STR);
      $stmt->bindParam(':cikod', $cikod, PDO::PARAM_STR);  
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
      $stmt->bindParam(':kulso', $kulso, PDO::PARAM_STR);
	  echo query_print($stmt);      
  }        
  function ellenor_cikklist($r){
      $sql="SELECT CIKK, CIKKNEV||case ";
      $sql.="  when (abs(drb) = coalesce(drb2,0) ) then '|@@style:listtitle;listtitledone' ";
      $sql.= " when (coalesce(drb2,0)=0) then '|@@style:listtitle;listtitlewait' ";
      $sql.= " when (abs(drb) > coalesce(drb2,0) and coalesce(drb2,0)>0) then '|@@style:listtitle;listtitlework' end CIKKNEV,";

      $sql.= " 'Kiszedve: '||cast(DRB as integer)||case ";
      $sql.="  when (abs(drb) = coalesce(drb2,0)) then '|@@style:listtitle;listtitledone' ";
      $sql.= " when (coalesce(drb2,0)=0) then '|@@style:listtitle;listtitlewait' ";
      $sql.= " when (abs(drb) > coalesce(drb2,0) and coalesce(drb2,0)>0) then '|@@style:listtitle;listtitlework' end DRB,";
      
      $sql.= " 'Ellenorizve: '||cast(coalesce(DRB2,0) as integer)||case ";
      $sql.="  when (abs(drb) = coalesce(drb2,0) ) then '|@@style:listtitle;listtitledone' ";
      $sql.= " when (coalesce(drb2,0)=0) then '|@@style:listtitle;listtitlewait' ";
      $sql.= " when (abs(drb) > coalesce(drb2,0) and coalesce(drb2,0)>0) then '|@@style:listtitle;listtitlework' end DRB2";      
      
      $sql.= "  FROM ANDROID_KIADELLENOR_REVIEW(:login,:azon,:szuro)";
      $stmt = query_prepare($sql);
      $login=trim($r['p1']);
      $azon=trim($r['p2']);
      $szuro='N';
      if (isset($r['p3'])) $szuro=trim($r['p3']);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
      $stmt->bindParam(':szuro', $szuro, PDO::PARAM_STR);
	  echo query_print($stmt);
  }
  function ellenor_kesobb($r){
      $sql="SELECT RESULT,RESULTTEXT ";      
      $sql.= "  FROM ANDROID_KIADELLENOR_KESOBBFOLYT(:login,:azon)";
      $stmt = query_prepare($sql);
      $login=trim($r['p1']);
      $azon=trim($r['p2']);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
	  echo query_print($stmt);
      Firebird::commit();
  }
  function ellenor_mentes($r){
      $sql = "SELECT RESULTTEXT,RESULT FROM ANDROID_KIADELLENOR_MENTES(:azon, :cikk, :ean, :drb2, :login, :kulso)";
      $stmt = query_prepare($sql);
      
      $azon=trim($r['p1']);
      $cikk=trim($r['p2']);
      $ean=trim($r['p3']);
      $drb2=trim($r['p4']);
      $login=trim($r['p5']);
      $kulso=trim($r['p6']);
      if ($ean=='.') $ean='';
      if ($cikk=='.') $cikk='';
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
      $stmt->bindParam(':cikk', $cikk, PDO::PARAM_STR);
      $stmt->bindParam(':drb2', $drb2, PDO::PARAM_STR);
      $stmt->bindParam(':ean', $ean, PDO::PARAM_STR);
      $stmt->bindParam(':kulso', $kulso, PDO::PARAM_STR);
	  echo query_print($stmt);      
      Firebird::commit();
  }

  
  function ellenor_lezaras($r){
      $azon=trim($r['p1']);
      $login=trim($r['p2']);

	  $sql = "SELECT BIZTIP FROM BFEJ WHERE AZON=:azon";
	  $stmt = query_prepare($sql);
	  $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
	  $q = query_exec($stmt);
	  $biztip = $q[0]['BIZTIP'];
	  $param='KULDES';
	  if ($biztip=='AF15') $param='DEV_KULDES';
	  logol('[kiadellenor lezar] azon:'.$azon.' biztip:'.$biztip);
	  
	  
      $sql = "SELECT RESULTTEXT FROM ANDROID_KIADELLENOR_LEZAR(:login,:azon)";
      $stmt = query_prepare($sql);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
      $q = query_exec($stmt);
	  echo $res = response_print($q);
	  Firebird::commit();
	  //email
      foreach ($q as $row) {
		foreach ($row as $k => $v) {
			//$line .= "[[$k=$v]]";
			if ($v=='OKELTERES') expaMail($azon,$param);
		}
	  }
	  
      
  }
  
  /* kiadas ellenor eddig*/  
  
?>
