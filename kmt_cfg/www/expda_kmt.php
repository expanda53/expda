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
     
     $arr = Firebird::prepare($sql,'kmt');
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
      $sql="SELECT RESULT FROM ANDROID_HKOD_CHECK(:hkod)";
      $stmt = query_prepare($sql);
      $hkod=trim($r['p1']);
      $hkod=str_replace('%20',' ',$hkod);
	  $stmt->bindParam(':hkod', $hkod, PDO::PARAM_STR);
	  echo query_print($stmt);
  }    
  function cikkval_open($r){
      $sql="SELECT KOD||'|@@style:listtitle' KOD,NEV||'|@@style:listtitle' NEV FROM ANDROID_CIKK_KERES(:betuz,30,:filterstr)";
      $stmt = query_prepare($sql);
      $betuz=trim($r['p1']);
      $betuz=str_replace('%20',' ',$betuz);
      $betuz=utf8_decode($betuz);
      
      $filterstr = trim($r['p2']);
      
	  $stmt->bindParam(':betuz', $betuz, PDO::PARAM_STR);
	  $stmt->bindParam(':filterstr', $filterstr, PDO::PARAM_STR);
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
        Firebird::commit();
  }
  /* login eddig */

  /* beerkezes */

  function beerk_mibizlist($r){
      $sql="SELECT NEV||'|@@style:listtitle' NEV,MIBIZ||'|@@style:listtitle' MIBIZ,AZON||'|@@style:listhidden' AZON FROM ANDROID_BEERK_MIBIZLIST(:login)";
      $stmt = query_prepare($sql);
      $login=trim($r['p1']);
      $stmt->bindParam(':login', $login, PDO::PARAM_STR);
	  echo query_print($stmt);
  }    
  

  function beerk_lotkeres($r){
      $sql = "SELECT CIKK,CIKKNEV, DRB, RESULT FROM ANDROID_BEERK_LOTKERES(:azon,:lot,:login)";
      $stmt = query_prepare($sql);
      
      $azon=trim($r['p1']);
      $lot=trim($r['p2']);
      $login=trim($r['p3']);
      if ($lot=='.') $lot='';
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':lot', $lot, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
	  echo query_print($stmt);      
  }  
  function beerk_ment($r){
      $sql = "SELECT RESULT,RESULTTEXT FROM ANDROID_BEERK_MENTES(:azon, :lot, :drb, :hkod,:login)";
      $stmt = query_prepare($sql);
      
      $azon=trim($r['p1']);
      $lot=trim($r['p2']);
      $drb=trim($r['p3']);
      $hkod=trim($r['p4']);
      $hkod=str_replace('%20',' ',$hkod);
      $login=trim($r['p5']);
      
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
      $stmt->bindParam(':drb', $drb, PDO::PARAM_STR);
      $stmt->bindParam(':lot', $lot, PDO::PARAM_STR);
      $stmt->bindParam(':hkod', $hkod, PDO::PARAM_STR);
	  echo query_print($stmt);      
      Firebird::commit();
  }
  
  function beerk_cikklist($r){
      $sql="SELECT CIKK, CIKKNEV, LOT, DRB FROM ANDROID_BEERK_REVIEW(:login,:mibiz)";
      $stmt = query_prepare($sql);
      $login=trim($r['p1']);
      $mibiz=trim($r['p2']);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':mibiz', $mibiz, PDO::PARAM_STR);
	  echo query_print($stmt);
  }  
  /* beerkezes eddig */

  /* keszrejel innen */
  function keszrejel_mibizlist($r){
      $sql="SELECT AZON,MIBIZ FROM ANDROID_KESZREJEL_MIBIZLIST(:login)";
      $stmt = query_prepare($sql);
      $login=trim($r['p1']);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
	  echo query_print($stmt);
  }  
  function keszrejel_cikkcheck($r){
      $sql="SELECT RESULT,CIKKNEV FROM ANDROID_KESZREJEL_CIKKCHECK(:cikk)";
      $stmt = query_prepare($sql);
      $cikk=trim($r['p1']);
	  $stmt->bindParam(':cikk', $cikk, PDO::PARAM_STR);
	  echo query_print($stmt);
  }    
  /* keszrejel eddig */
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
      $sql = "SELECT CIKKNEV||'|@@style:labeldefault' CIKKNEV,DRB||'|@@style:labeldefault' DRB, CIKK AS KOD FROM ANDROID_HKODRA_HKKLT(:hkod,:kulso)";
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
      $sql = "SELECT RESULT,RESULTTEXT,MIBIZ,AZON FROM ANDROID_HKODRA_MENTES(:azon, :hkod, :cikk, :ean, :drb, :login,:kulso)";
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
  
  function ellenor_ujra($r){
      $azon=trim($r['p1']);
      $login=trim($r['p2']);
	  
      $sql = "SELECT RESULTTEXT FROM ANDROID_KIADELLENOR_UJRA(:login,:azon)";
      $stmt = query_prepare($sql);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
      $q = query_exec($stmt);
	  echo $res = response_print($q);
	  Firebird::commit();

  }
  
  
  /* kiadas ellenor eddig*/  
  /* koltozes innen */
  function bevetkolt_init($r){
      $sql="SELECT AZON,MIBIZ,RESULT FROM ANDROID_BEVETKOLT_INIT(:hkod,:login)";
      $stmt = query_prepare($sql);
      $hkod=trim($r['p1']);
      $login=trim($r['p2']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':hkod', $hkod, PDO::PARAM_STR);
	  echo query_print($stmt);
  }  
  function bevetkolt_ment($r){
      $sql = "SELECT RESULT,RESULTTEXT,MIBIZ,AZON FROM ANDROID_BEVETKOLT_MENTES(:azon, :hkod, :cikk, :ean, :drb, :login,:kulso,:hkod_regi)";
      $stmt = query_prepare($sql);
      
      $azon=trim($r['p1']);
      $hkod=trim($r['p2']);
      $cikk=trim($r['p3']);
      $ean=trim($r['p4']);
      $drb=trim($r['p5']);
      $login=trim($r['p6']);
      $kulso=trim($r['p7']);
      $hkod_regi=trim($r['p8']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
      $stmt->bindParam(':drb', $drb, PDO::PARAM_STR);
      $stmt->bindParam(':hkod', $hkod, PDO::PARAM_STR);
      $stmt->bindParam(':hkod_regi', $hkod_regi, PDO::PARAM_STR);
      $stmt->bindParam(':ean', $ean, PDO::PARAM_STR);
      $stmt->bindParam(':cikk', $cikk, PDO::PARAM_STR);
      $stmt->bindParam(':kulso', $kulso, PDO::PARAM_STR);
	  echo query_print($stmt);      
      Firebird::commit();
  }
  function bevetkolt_lezaras($r){
      $sql = "SELECT RESULT,RESULTTEXT FROM ANDROID_BEVETKOLT_LEZAR(:login, :azon)";
      $stmt = query_prepare($sql);
      
      $azon=trim($r['p1']);
      $login=trim($r['p2']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
	  echo query_print($stmt);      
      Firebird::commit();
  }  
  /* koltozes eddig */
       
?>
