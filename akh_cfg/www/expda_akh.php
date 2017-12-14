<?php
//   error_reporting(0);
  require_once 'firebird.php';
  require_once 'converter.php';
  header('Access-Control-Allow-Origin: *');  
  date_default_timezone_set('Europe/Budapest');
  
 
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
     $arr = Firebird::prepare($sql);
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
    Firebird::commit();
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
   
  /* altalanos eddig*/
  /* login */
  function login_check($r){
        $sql="SELECT RESULTTEXT FROM ANDROID_LOGIN_CHECK(:login)";
        $stmt = query_prepare($sql);
        
		$login=trim($r['p1']);
		$stmt->bindParam(':login', $login, PDO::PARAM_STR);
		echo query_print($stmt);
        //Firebird::commit();
  }
  /* login eddig */
  /* leltar innen */
  function leltar_mibizlist($r){
      $sql="SELECT FEJAZON AS AZON,LEIR||'|@@style:listtitle;listtitledone' AS MIBIZ,LEIR, RESULT FROM ANDROID_LELTAR_MIBIZLIST(:login)";
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
  }
  
  function leltar_hkod_check($r){
      $sql="SELECT RESULT FROM ANDROID_LELTAR_HKOD_CHECK(:azon, :hkod, :login)";
      $stmt = query_prepare($sql);
      $azon=trim($r['p1']);      
      $hkod=trim($r['p2']); 
      $login=trim($r['p3']);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
	  $stmt->bindParam(':hkod', $hkod, PDO::PARAM_STR);
      $stmt->bindParam(':login', $login, PDO::PARAM_STR);
	  echo query_print($stmt);
   }  
  
  
  function leltar_ean_check($r){
      $sql="SELECT CIKK,CIKKNEV,RESULT FROM ANDROID_LELTAR_EAN_CHECK(:azon, :hkod, :ean, :login)";
      $stmt = query_prepare($sql);
      $ean=trim($r['p1']);
      $azon=trim($r['p2']);      
      $hkod=trim($r['p3']);      
      $login=trim($r['p4']);
      if ($ean=='.') $ean='';
	  $stmt->bindParam(':ean', $ean, PDO::PARAM_STR);
	  $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
	  $stmt->bindParam(':hkod', $hkod, PDO::PARAM_STR);
      $stmt->bindParam(':login', $login, PDO::PARAM_STR);      
	  echo query_print($stmt);
  }

  function leltar_drb_check($r){
      $sql="SELECT DRB,RESULT FROM ANDROID_LELTAR_DRB_CHECK(:azon, :hkod, :cikk, :dot,:login)";
      $stmt = query_prepare($sql);
      $cikk=trim($r['p1']);
      $azon=trim($r['p2']);      
      $hkod=trim($r['p3']);      
      $dot=trim($r['p4']);
      $login=trim($r['p5']);
      if ($cikk=='.') $cikk='';
      if ($dot=='.') $dot='';
	  $stmt->bindParam(':cikk', $cikk, PDO::PARAM_STR);
	  $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
	  $stmt->bindParam(':hkod', $hkod, PDO::PARAM_STR);
	  $stmt->bindParam(':dot', $dot, PDO::PARAM_STR);
      $stmt->bindParam(':login', $login, PDO::PARAM_STR);      
	  echo query_print($stmt);
  }  
  

  function leltar_ment($r){
      $sql = "SELECT RESULT,RESULTTEXT FROM ANDROID_LELTAR_MENTES(:azon, :hkod, :cikk, :ean, :drb, :dot, :login)";
      $stmt = query_prepare($sql);
      
      $azon=trim($r['p1']);
      $hkod=trim($r['p2']);
      $cikk=trim($r['p3']);
      $ean=trim($r['p4']);
      $drb=trim($r['p5']);
      $dot=trim($r['p6']);
      $login=trim($r['p7']);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
      $stmt->bindParam(':drb', $drb, PDO::PARAM_STR);
      $stmt->bindParam(':hkod', $hkod, PDO::PARAM_STR);
      $stmt->bindParam(':ean', $ean, PDO::PARAM_STR);
      $stmt->bindParam(':cikk', $cikk, PDO::PARAM_STR);
      $stmt->bindParam(':dot', $dot, PDO::PARAM_STR);

	  echo query_print($stmt);      
  }
  
  function leltar_review($r){
      $sql="SELECT CIKKNEV||'|@@style:listtitle;listtitledone' CIKKNEV, ";
      $sql.= " 'Hkód: '||HKOD||'|@@style:listdetails;listtitledone' HKOD, ";      
      $sql.= " 'EAN: '||EAN||'|@@style:listdetails;listtitledone' EAN, ";
      $sql.= " 'DOT: '||DOT||'|@@style:listdetails;listtitledone' DOT, ";      
      $sql.= " 'Összesen: '||cast(DRB as integer)||'|@@style:listdetails;listtitledone' DRB ";
      $sql.= " FROM ANDROID_LELTAR_REVIEW(:azon,:login)";
      $stmt = query_prepare($sql);
      $login=trim($r['p1']);
      $azon=trim($r['p2']);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
	  echo query_print($stmt);
  }    
  
  function leltar_kesobbfolyt($r){
      $sql = "SELECT RESULT FROM ANDROID_LELTAR_KESOBBFOLYT(:login, :azon)";
      $stmt = query_prepare($sql);
      
      $azon=trim($r['p1']);
      $login=trim($r['p2']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
	  echo query_print($stmt);      
  }
  
  function leltar_lezaras($r){
      $sql = "SELECT RESULT,RESULTTEXT FROM ANDROID_LELTAR_LEZAR(:login, :azon)";
      $stmt = query_prepare($sql);
      
      $azon=trim($r['p1']);
      $login=trim($r['p2']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':azon', $azon, PDO::PARAM_STR);
	  echo query_print($stmt);      
  }
  
/* leltar eddig */      
  
?>
