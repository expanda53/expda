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
      $sql="SELECT CEGNEV||'|@@style:listtitle' CEGNEV,mibiz||'|@@style:listdetails' MIBIZ FROM ANDROID_KIADAS_MIBIZLIST(':login')";
      $stmt = query_prepare($sql);
      $login=trim($r['p1']);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
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

  function kiadas_kovsor($r){
      $sql="SELECT CIKK, CIKKNEV, KOD2 EAN, cast(DRB as integer) DRB, cast(DRB2 as integer) DRB2, SORSZ FROM ANDROID_KIADAS_KOVSOR(:mibiz,:aktsorsz,:irany)";
      $stmt = query_prepare($sql);
      $login=trim($r['p1']);
      $mibiz=trim($r['p2']);
      $aktsorsz=trim($r['p3']);
      $irany=trim($r['p4']);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':mibiz', $mibiz, PDO::PARAM_STR);
      $stmt->bindParam(':aktsorsz', $aktsorsz, PDO::PARAM_STR);
      $stmt->bindParam(':irany', $irany, PDO::PARAM_STR);      
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
      $sql = "SELECT TOBBLET,HIANY,KIADVA,RESULTTEXT FROM ANDROID_KIADAS_LEZAR_CHECK(:mibiz)";
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
  /* bevet */
  function bevet_mibizlist($r){
      $sql="SELECT CEGNEV||'|@@style:listtitle' CEGNEV,mibiz||'|@@style:listdetails' MIBIZ FROM ANDROID_BEVET_MIBIZLIST(':login')";
      $stmt = query_prepare($sql);
      $login=trim($r['p1']);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
	  echo query_print($stmt);
  }  
  function bevet_cikklist($r){
      $sql="SELECT SORSZ, CIKKNEV||case when (abs(drb) = drb2 ) then '|@@style:listtitle;listtitledone' ";
      $sql.= " when (drb2=0) then '|@@style:listtitle;listtitlewait' ";
      $sql.= " when (abs(drb) > drb2 and drb2>0) then '|@@style:listtitle;listtitlework' end CIKKNEV, ";
      
      $sql.= " KOD2||case when (abs(drb) = drb2 ) then '|@@style:listdetails;listtitledone' ";
      $sql.= " when (drb2=0) then '|@@style:listdetails;listtitlewait' ";
      $sql.= " when (abs(drb) > drb2 and drb2>0) then '|@@style:listdetails;listtitlework' end EAN, ";
      
      $sql.= " 'Összesen: '||cast(DRB as integer)||case when (abs(drb) = drb2 ) then '|@@style:listdetails;listtitledone' ";
      $sql.= " when (drb2=0) then '|@@style:listdetails;listtitlewait' ";
      $sql.= " when (abs(drb) > drb2 and drb2>0) then '|@@style:listdetails;listtitlework' end DRB, ";
      
      $sql.= " 'Bevéve: '||cast(DRB2 as integer)||case when (abs(drb) = drb2 ) then '|@@style:listdetails;listtitledone' ";
      $sql.= " when (drb2=0) then '|@@style:listdetails;listtitlewait' ";
      $sql.= " when (abs(drb) > drb2 and drb2>0) then '|@@style:listdetails;listtitlework' end DRB2 FROM ANDROID_CIKKLISTA(:mibiz)";
      $stmt = query_prepare($sql);
      $login=trim($r['p1']);
      $mibiz=trim($r['p2']);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':mibiz', $mibiz, PDO::PARAM_STR);
	  echo query_print($stmt);
  }  
  function bevet_gyszam_ment($r){
      $sql = "SELECT RESULTTEXT,DRB2 FROM ANDROID_BEVET_GYSZAM_MENT(:mibiz, :sorsz, :ean, :gyszam, :login)";
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
  function bevet_lezaras($r){
      $sql = "SELECT RESULTTEXT FROM ANDROID_BEVET_LEZAR(:mibiz,:login)";
      $stmt = query_prepare($sql);
      
      $mibiz=trim($r['p1']);
      $login=trim($r['p2']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':mibiz', $mibiz, PDO::PARAM_STR);
	  echo query_print($stmt);      
      Firebird::commit();
  }  
  /* bevet eddig */
  /* gyszam leltar innen */
  function gyszamleltar_init($r){
      $sql="SELECT MIBIZ FROM ANDROID_GYSZAMLELTAR_INIT(:login)";
      $stmt = query_prepare($sql);
      $login=trim($r['p1']);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
	  echo query_print($stmt);
  }  

  function gyszamleltar_cikk_keres($r){
      $sql="SELECT KOD,NEV,RAKTARBAN,SZAMOLT FROM ANDROID_GYSZAMLELTAR_CIKK(:mibiz,:ean)";
      $stmt = query_prepare($sql);
      $mibiz=trim($r['p1']);
      $ean=trim($r['p2']);
	  $stmt->bindParam(':ean', $ean, PDO::PARAM_STR);
      $stmt->bindParam(':mibiz', $mibiz, PDO::PARAM_STR);
	  echo query_print($stmt);
  }  
  function gyszamleltar_gyszam_ment($r){
      $sql = "SELECT RESULTTEXT,DRB2,VMIBIZ FROM ANDROID_GYSZAMLELTAR_MENT(:mibiz, :cikk, :ean, :gyszam, :login)";
      $stmt = query_prepare($sql);
      
      $mibiz=trim($r['p1']);
      $cikk=trim($r['p2']);
      $ean=trim($r['p3']);
      $gyszam=trim($r['p4']);
      $login=trim($r['p5']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':mibiz', $mibiz, PDO::PARAM_STR);
      $stmt->bindParam(':cikk', $cikk, PDO::PARAM_STR);
      $stmt->bindParam(':gyszam', $gyszam, PDO::PARAM_STR);
      $stmt->bindParam(':ean', $ean, PDO::PARAM_STR);
	  echo query_print($stmt);      
      Firebird::commit();
  }
  function gyszamleltar_gyszamlist($r){
      $sql = "SELECT GYSZAM||'|@@style:listtitle;listtitlewait' as GYSZAM FROM ANDROID_GYSZAMLELTAR_GYSZAMLIST(:mibiz, :cikk, :login)";
      $stmt = query_prepare($sql);
      
      $mibiz=trim($r['p1']);
      $cikk=trim($r['p2']);
      $login=trim($r['p3']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':mibiz', $mibiz, PDO::PARAM_STR);
      $stmt->bindParam(':cikk', $cikk, PDO::PARAM_STR);
	  echo query_print($stmt);      
      Firebird::commit();
  }  
  function gyszamleltar_gyszam_torol($r){
      $sql = "SELECT RESULTTEXT,DRB2 FROM ANDROID_GYSZAMLELTAR_GYSZTOROL(:mibiz, :cikk, :gyszam,:login)";
      $stmt = query_prepare($sql);
      
      $mibiz=trim($r['p1']);
      $cikk=trim($r['p2']);
      $gyszam=trim($r['p3']);
      $login=trim($r['p4']);
      
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':mibiz', $mibiz, PDO::PARAM_STR);
      $stmt->bindParam(':cikk', $cikk, PDO::PARAM_STR);
      $stmt->bindParam(':gyszam', $gyszam, PDO::PARAM_STR);
	  echo query_print($stmt);      
      Firebird::commit();
  }
  
  function gyszamleltar_cikklist($r){
      $sql="SELECT CIKK,CIKKNEV||'|@@style:listtitle;listtitledone' CIKKNEV, ";
      $sql.= " KOD2||'|@@style:listdetails;listtitledone' EAN, ";
      $sql.= " 'Összesen: '||cast(DRB as integer)||'|@@style:listdetails;listtitledone' DRB ";
      $sql.= " FROM ANDROID_GYSZAMLELTAR_CIKKEK(:mibiz)";
      $stmt = query_prepare($sql);
      $login=trim($r['p1']);
      $mibiz=trim($r['p2']);
	  $stmt->bindParam(':login', $login, PDO::PARAM_STR);
      $stmt->bindParam(':mibiz', $mibiz, PDO::PARAM_STR);
	  echo query_print($stmt);
  }    
/* gyszam leltar eddig */
?>
