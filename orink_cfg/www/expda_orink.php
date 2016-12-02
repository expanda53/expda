<?php
  // error_reporting(0);
  require_once 'firebird.php';
  require_once 'converter.php';
  header('Access-Control-Allow-Origin: *');  
  function leftcut ($arg1, $arg2) {
     $arg2 = '/'.$arg2.'/';
     $vissza = preg_split($arg2, $arg1);
     return $vissza;
  }
  
  function logol($szoveg) {
       //return false;
	   
       $dat=date('y.m.d H:i:s');
	   $datd=date('y.m.d');
	   $dats=str_replace('.','',$datd);
	   
       
       $ip = strip_tags($_SERVER['REMOTE_ADDR']);
       if ($ip=='::1') $ip='127001';
	   $fnev = str_replace('.','',$ip).'_'.$dats.'.log';
	   @mkdir("log", 0700);
       $fnev="log/$fnev";
       $fp = fopen($fnev, 'a');
       $szoveg1='###'.$dat." $ip:";
       $return=" \r\n";
       fwrite($fp, $szoveg1.$szoveg.$return);
       fwrite($fp, '*****'.$return);
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
   logol('start: '.json_encode($_REQUEST))  ;
   call_user_func($command,$_REQUEST);
   logol('finish: '.$command)  ;

  }
  else if ($command=='') echo "welcome, no command";
  else {logol('function not exists:'.$command. ' params: '.json_encode($_REQUEST));echo "'$command' function doesn't exist";}
  

  function query_prepare($sql){
     logol($sql);
     
     $arr = Firebird::prepare($sql);
     if (!$arr) {
         $errors = Firebird::errorInfo();
         logol($errors[2]);
     }

     return $arr;
  }
  function query_exec($stmt){
        $stmt->execute();
        if($stmt->errorCode() == 0) {
        } else {
            $errors = $stmt->errorInfo();
            logol($errors[2]);
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
  function ean_check($r){
      $sql="SELECT CIKK,CIKKNEV,RESULT FROM ANDROID_EAN_CHECK(:ean)";
      $stmt = query_prepare($sql);
      $ean=trim($r['p1']);
	  $stmt->bindParam(':ean', $ean, PDO::PARAM_STR);
	  echo query_print($stmt);
  }  

  function hkod_check($r){
      $sql="SELECT RESULT FROM ANDROID_HKOD_CHECK(:hkod)";
      $stmt = query_prepare($sql);
      $hkod=trim($r['p1']);
	  $stmt->bindParam(':hkod', $hkod, PDO::PARAM_STR);
	  echo query_print($stmt);
  }    
  function cikkval_open($r){
      $sql="SELECT KOD,NEV||'|@@style:listtitle' NEV FROM ANDROID_CIKK_KERES(:betuz,30)";
      $stmt = query_prepare($sql);
      $betuz=trim($r['p1']);
	  $stmt->bindParam(':betuz', $betuz, PDO::PARAM_STR);
	  echo query_print($stmt);      
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
      $sql="SELECT CEGNEV||'|@@style:listtitle' CEGNEV,";
      $sql.="mibiz||'|@@style:listdetails' MIBIZ,";
      $sql.="'Szállmód:'||COALESCE(SZALLMOD,'')||'|@@style:listdetails' SZALLMOD,";
      $sql.="'Súly:'||CAST(SULY AS NUMERIC(10,2))||'|@@style:listdetails' SULY,";
      $sql.="'Térf:'||CAST(TERFOGAT AS NUMERIC(10,2))||'|@@style:listdetails' TERFOGAT,";      
      $sql.="'Sorok:'||SORDB||'|@@style:listdetails' SORDB,AZON";            
      $sql.="      FROM ANDROID_KIADAS_MIBIZLIST(:login)";
      $stmt = query_prepare($sql);
      $login=trim($r['p1']);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
	  echo query_print($stmt);
  }
  function kiadas_kovsor($r){
      $sql="SELECT CIKK, CIKKNEV, HKOD, cast(DRB as integer) DRB, cast(DRB2 as integer) DRB2, SULY,TERFOGAT,RESULT FROM ANDROID_KIADAS_LEPTET(:azon,:hkod,:cikk,:irany,:login)";
      $stmt = query_prepare($sql);
      $azon=trim($r['p1']);
      $hkod=trim($r['p2']);
      $cikk=trim($r['p3']);
      $irany=trim($r['p4']);
      $login=trim($r['p5']);
      
      if ($cikk=='.') $cikk='';
      if ($hkod=='.') $hkod='';
      logol('cikk:'.$cikk.'_');
      logol('hkod:'.$hkod.'_');
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
      $stmt->bindParam(':hkod', $hkod, PDO::PARAM_STR);
      $stmt->bindParam(':cikk', $cikk, PDO::PARAM_STR);
      $stmt->bindParam(':irany', $irany, PDO::PARAM_STR);      
	  echo query_print($stmt);
  }
  

  
  
  function kiadas_review_sum($r){
      $sql="SELECT DRB,DRB2 FROM ANDROID_KIADAS_SUM(:mibiz)";
      $stmt = query_prepare($sql);
      $login=trim($r['p1']);
      $mibiz=trim($r['p2']);
	  //$stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':mibiz', $mibiz, PDO::PARAM_STR);
	  echo query_print($stmt);
  }

  function kiadas_cikklist($r){
      $sql="SELECT SORSZ, CIKKNEV||case when (abs(drb) = drb2 ) then '|@@style:listtitle;listtitledone' ";
      $sql.= " when (drb2=0) then '|@@style:listtitle;listtitlewait' ";
      $sql.= " when (abs(drb) > drb2 and drb2>0) then '|@@style:listtitle;listtitlework' end CIKKNEV, ";
      
      $sql.= " KOD2||case when (abs(drb) = drb2 ) then '|@@style:listdetails;listtitledone' ";
      $sql.= " when (drb2=0) then '|@@style:listdetails;listtitlewait' ";
      $sql.= " when (abs(drb) > drb2 and drb2>0) then '|@@style:listdetails;listtitlework' end EAN, ";
      
      $sql.= " 'Összesen: '||cast(DRB as integer)||case when (abs(drb) = drb2 ) then '|@@style:listdetails;listtitledone' ";
      $sql.= " when (drb2=0) then '|@@style:listdetails;listtitlewait' ";
      $sql.= " when (abs(drb) > drb2 and drb2>0) then '|@@style:listdetails;listtitlework' end DRB, ";
      
      $sql.= " 'Kiszedve: '||cast(DRB2 as integer)||case when (abs(drb) = drb2 ) then '|@@style:listdetails;listtitledone' ";
      $sql.= " when (drb2=0) then '|@@style:listdetails;listtitlewait' ";
      $sql.= " when (abs(drb) > drb2 and drb2>0) then '|@@style:listdetails;listtitlework' end DRB2 FROM ANDROID_CIKKLISTA(:mibiz)";
      $stmt = query_prepare($sql);
      $login=trim($r['p1']);
      $mibiz=trim($r['p2']);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':mibiz', $mibiz, PDO::PARAM_STR);
	  echo query_print($stmt);
  }

 
  function kiadas_gyszam_ment($r){
      $sql = "SELECT RESULTTEXT,DRB2 FROM ANDROID_KIADAS_GYSZAM_MENT(:mibiz, :sorsz, :ean, :gyszam, :login)";
      $stmt = query_prepare($sql);
      
      $mibiz=trim($r['p1']);
      $sorsz=trim($r['p2']);
      $ean=trim($r['p3']);
      $gyszam=trim($r['p4']);
      $login=trim($r['p5']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':mibiz', $mibiz, PDO::PARAM_STR);
      $stmt->bindParam(':sorsz', $sorsz, PDO::PARAM_STR);
      $stmt->bindParam(':gyszam', $gyszam, PDO::PARAM_STR);
      $stmt->bindParam(':ean', $ean, PDO::PARAM_STR);
	  echo query_print($stmt);      
      Firebird::commit();
  }

  function kiadas_gyszam_torol($r){
      $sql = "SELECT RESULTTEXT,DRB2 FROM ANDROID_KIADAS_GYSZAM_TOROL(:mibiz, :sorsz, :gyszam,:login)";
      $stmt = query_prepare($sql);
      
      $mibiz=trim($r['p1']);
      $sorsz=trim($r['p2']);
      $gyszam=trim($r['p3']);
      $login=trim($r['p4']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':mibiz', $mibiz, PDO::PARAM_STR);
      $stmt->bindParam(':sorsz', $sorsz, PDO::PARAM_STR);
      $stmt->bindParam(':gyszam', $gyszam, PDO::PARAM_STR);
	  echo query_print($stmt);      
      Firebird::commit();
  }
  function kiadas_gyszamlist($r){
      $sql = "SELECT GYSZAM||'|@@style:listtitle;listtitlewait' as GYSZAM FROM ANDROID_KIADAS_GYSZAM_LIST(:mibiz, :sorsz, :login)";
      $stmt = query_prepare($sql);
      
      $mibiz=trim($r['p1']);
      $sorsz=trim($r['p2']);
      $login=trim($r['p3']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':mibiz', $mibiz, PDO::PARAM_STR);
      $stmt->bindParam(':sorsz', $sorsz, PDO::PARAM_STR);
	  echo query_print($stmt);      
      Firebird::commit();
  }
  function kiadas_lezaras_check($r){
      $sql = "SELECT TOBBLET,HIANY,KIADVA FROM ANDROID_KIADAS_LEZAR_CHECK(:mibiz)";
      $stmt = query_prepare($sql);
      
      $mibiz=trim($r['p1']);
      $login=trim($r['p2']);
      
	  //$stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':mibiz', $mibiz, PDO::PARAM_STR);
	  echo query_print($stmt);      
      Firebird::commit();
  }
  function kiadas_lezaras($r){
      $sql = "SELECT RESULTTEXT FROM ANDROID_KIADAS_LEZAR(:mibiz,:login)";
      $stmt = query_prepare($sql);
      
      $mibiz=trim($r['p1']);
      $login=trim($r['p2']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':mibiz', $mibiz, PDO::PARAM_STR);
	  echo query_print($stmt);      
      Firebird::commit();
  }
  /* kiadas eddig */
  /* beerkezes */

  function beerk_ceglist($r){
      $sql="SELECT NEV||'|@@style:listtitle' NEV,AZON||'|@@style:listhidden' AZON FROM ANDROID_BEERK_CEGLIST";
      $stmt = query_prepare($sql);
	  echo query_print($stmt);
  }    
  
  function beerk_bizkeres($r){
      $sql = "SELECT AZON,MIBIZ FROM ANDROID_BEERK_BIZKERES(:ceg,:login)";
      $stmt = query_prepare($sql);
      
      $ceg=trim($r['p1']);
      $login=trim($r['p2']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':ean', $ean, PDO::PARAM_STR);
      $stmt->bindParam(':ceg', $ceg, PDO::PARAM_STR);
	  echo query_print($stmt);      
  }  
  function beerk_eankeres($r){
      $sql = "SELECT CIKK,CIKKNEV, DRB, DRB2, RESULT FROM ANDROID_BEERK_EANKERES(:ceg,:ean,:login)";
      $stmt = query_prepare($sql);
      
      $ceg=trim($r['p1']);
      $ean=trim($r['p2']);
      $login=trim($r['p3']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':ean', $ean, PDO::PARAM_STR);
      $stmt->bindParam(':ceg', $ceg, PDO::PARAM_STR);
	  echo query_print($stmt);      
  }  
  function beerk_ment($r){
      $sql = "SELECT RESULT,RESULTTEXT,MIBIZ,AZON FROM ANDROID_BEERK_MENTES(:azon, :ceg, :cikk, :ean, :drb, :login)";
      $stmt = query_prepare($sql);
      
      $azon=trim($r['p1']);
      $ceg=trim($r['p2']);
      $cikk=trim($r['p3']);
      $ean=trim($r['p4']);
      $drb=trim($r['p5']);
      $login=trim($r['p6']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
      $stmt->bindParam(':drb', $drb, PDO::PARAM_STR);
      $stmt->bindParam(':ceg', $ceg, PDO::PARAM_STR);
      $stmt->bindParam(':ean', $ean, PDO::PARAM_STR);
      $stmt->bindParam(':cikk', $cikk, PDO::PARAM_STR);
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
      $sql = "SELECT RESULTTEXT FROM ANDROID_BEERK_LEZAR(:login,:azon)";
      $stmt = query_prepare($sql);
      
      $login=trim($r['p1']);
      $azon=trim($r['p2']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
	  echo query_print($stmt);      
      Firebird::commit();
  }  
  /* bevet eddig */
  /* leltar innen */
  function leltar_mibizlist($r){
      $sql="SELECT AZON,MIBIZ FROM ANDROID_LELTAR_MIBIZLIST(:login)";
      $stmt = query_prepare($sql);
      $login=trim($r['p1']);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
	  echo query_print($stmt);
  }  

  function leltar_init($r){
      $sql="SELECT RESULT,RESULTTEXT FROM ANDROID_LELTAR_INIT(:azon,:login)";
      $stmt = query_prepare($sql);
      $azon=trim($r['p1']);
      $login=trim($r['p2']);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
	  echo query_print($stmt);
      Firebird::commit();
  }  

  function leltar_ment($r){
      $sql = "SELECT RESULT,RESULTTEXT,MIBIZ,AZON FROM ANDROID_LELTAR_MENTES(:azon, :hkod, :cikk, :ean, :drb, :login)";
      $stmt = query_prepare($sql);
      
      $azon=trim($r['p1']);
      $hkod=trim($r['p2']);
      $cikk=trim($r['p3']);
      $ean=trim($r['p4']);
      $drb=trim($r['p5']);
      $login=trim($r['p6']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
      $stmt->bindParam(':drb', $drb, PDO::PARAM_STR);
      $stmt->bindParam(':hkod', $hkod, PDO::PARAM_STR);
      $stmt->bindParam(':ean', $ean, PDO::PARAM_STR);
      $stmt->bindParam(':cikk', $cikk, PDO::PARAM_STR);
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
      $sql = "SELECT AZON,MIBIZ FROM ANDROID_HKODRA_INIT(:login)";
      $stmt = query_prepare($sql);
      $login=trim($r['p1']);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
	  echo query_print($stmt);      
  }
  function hkod_cikkhkklt($r){
      $sql = "SELECT ODRB - FDRB AS MAXKIDRB FROM ANDROID_HKODRA_CIKKHKKLT(:hkod, :cikk)";
      $stmt = query_prepare($sql);
      
      $hkod=trim($r['p1']);
      $cikk=trim($r['p2']);
      
	  $stmt->bindParam(':hkod', $hkod, PDO::PARAM_STR);
      $stmt->bindParam(':cikk', $cikk, PDO::PARAM_STR);
	  echo query_print($stmt);      
  }
  function hkod_hkklt($r){
      $sql = "SELECT CIKKNEV||'|@@style:labeldefault' CIKKNEV,DRB||'|@@style:labeldefault' DRB FROM ANDROID_HKODRA_HKKLT(:hkod)";
      $stmt = query_prepare($sql);
      if (isset($r['p1'])) $hkod=trim($r['p1']);
      else $hkod='';
      
	  $stmt->bindParam(':hkod', $hkod, PDO::PARAM_STR);
	  echo query_print($stmt);      
  }  
  function hkod_cikkklt($r){
      $sql = "SELECT HKOD||'|@@style:labeldefault' HKOD,DRB||'|@@style:labeldefault' DRB FROM ANDROID_HKODRA_CIKKKLT(:cikk)";
      $stmt = query_prepare($sql);
      if (isset($r['p1'])) $cikk=trim($r['p1']);
      else $cikk='';
      
	  $stmt->bindParam(':cikk', $cikk, PDO::PARAM_STR);
	  echo query_print($stmt);      
  }    
  function hkod_ment($r){
      $sql = "SELECT RESULT,'' RESULTTEXT,MIBIZ,AZON FROM ANDROID_HKODRA_MENTES(:azon, :hkod, :cikk, :ean, :drb, :login)";
      $stmt = query_prepare($sql);
      
      $azon=trim($r['p1']);
      $hkod=trim($r['p2']);
      $cikk=trim($r['p3']);
      $ean=trim($r['p4']);
      $drb=trim($r['p5']);
      $login=trim($r['p6']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
      $stmt->bindParam(':drb', $drb, PDO::PARAM_STR);
      $stmt->bindParam(':hkod', $hkod, PDO::PARAM_STR);
      $stmt->bindParam(':ean', $ean, PDO::PARAM_STR);
      $stmt->bindParam(':cikk', $cikk, PDO::PARAM_STR);
	  echo query_print($stmt);      
      Firebird::commit();
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
?>
