<?php
  // error_reporting(0);
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
	   $fnev = str_replace('.','',$ip).'_'.$dats.'.log';
	   @mkdir("log", 0700);
       $fnev="log/$fnev";
       $fp = fopen($fnev, 'a');
       $szoveg1='###'.$dat." $ip:";
       $return=" \r\n";
       fwrite($fp, $szoveg1.$szoveg.$return);
       fclose($fp);
    }
	
	function parsing($array) {
		return "('".implode("', '", $array)."')";
	}
	
  //$host = '127.0.0.1:d:/alfa/tir/dat/toptyre2011/toptyre2011.gdb';
  $host = '192.168.2.1:c:\Expanda\alfa\tir\dat\toptyre2015\toptyre2015.gdb';

  $username='sysdba';
  $password='masterkey';      
  $db = ibase_connect( $host, $username, $password ) or die ("error in db connect");

  $dsn="mysql:host=www.expanda.hu;port=3306;dbname=pulykakakas;charset=utf8";
  $username = 'expanda';
  $password = 'abroszot624';
  $options = array(
    //PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8',
  ); 

  $dbh = new PDO($dsn, $username, $password, $options);  
  $command = '';
  if (isset($_REQUEST['command'])) $command=$_REQUEST['command'];
  $ix = 1;
  $par = array();
  while (isset($_REQUEST['p'.$ix])) {
	$par[]=urldecode($_REQUEST['p'.$ix]);
	$ix++;
  }

   // echo implode(',',$_REQUEST);
   // print_r($_REQUEST);
   if ($command==''){
   foreach ($_REQUEST as $p => $v){ 
		$command = $v;
		break;
   }
   }
   // print_r($_POST);
  if (function_exists($command)) {
   logol('start: '.$command)  ;
   if (stripos($command, 'mantis_')!==false){
	 call_user_func($command,$dbh,$par);
   }
   else
   call_user_func($command,$db,$par);
   logol('finish: '.$command)  ;

  }
  else if ($command=='') echo "welcome, no command";
  else {logol('function not exists:'.$command. ' params: '.json_encode($par));echo "'$command' function doesn't exist";}
  
  function query_print($db,$sql) {
    logol($sql);
	$fbh = ibase_query ($db, $sql); 
    if ($fbh===false) logol(ibase_errmsg()); 
  	$res = '';
	$line='';

	while ($q=ibase_fetch_assoc($fbh)) {
		$line = '';
		foreach ($q as $k => $v) {
			$line .= "[[$k=$v]]";
		}
		$res .= $line.chr(13).chr(10);
	}
	return utf8_encode($res);
  }
  function mysql_query_print($db,$sql){ 
    /*$stmt = $db->query($sql);
	while($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
		$line = '';
		foreach ($row as $k => $v) {
			$line .= "[[$k=$v]]";
		}
		$res .= $line.chr(13).chr(10);
	}
	*/
	$q = _mysql_query($db,$sql);
	$res = response_print($q);
	return $res;	
  }

  function _mysql_query($db,$sql){ 
    $stmt = $db->query($sql);
	$res=array();
	while($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
		$res[]=$row;
	}
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
	return $res;	
  }
  
  function KIADAS_MIBIZLIST($db, $par){
	$sql = "SELECT * FROM PDA_KIADAS_MIBIZLIST('".$par[0]."')";
	echo query_print($db,$sql);
  }
  
  function TASK_REFRESH($db, $par){
	$sql = "SELECT * FROM PDA_TASK_REFRESH('".$par[0]."','".$par[1]."')";
	echo query_print($db,$sql);
  }  
  
  function BEVET_MIBIZLIST($db, $par){
	$sql = "SELECT * FROM PDA_BEVET_MIBIZLIST('".$par[0]."')";
	echo query_print($db,$sql);
  }
    
  function HKODREND_MIBIZLIST($db, $par){
	$sql = "SELECT * FROM PDA_HKOD_MIBIZLIST('".$par[0]."')";
	echo query_print($db,$sql);
  }
  	
	
  function LELTAR_MIBIZLIST($db, $par){
	$sql = "SELECT * FROM PDA_LELTAR_MIBIZLIST('".$par[0]."')";
	echo query_print($db,$sql);
  }
  function ORZLELTAR_MIBIZLIST($db, $par){
	$sql = "SELECT * FROM PDA_ORZOTTLELTAR_MIBIZLIST('".$par[0]."')";
	echo query_print($db,$sql);
  }
  
  
  function CIKKVAL_LIST($db, $par){
	$sql = "SELECT * FROM PDA_CIKKVAL_LIST('".$par[0]."','".$par[1]."','".$par[2]."')";
	echo query_print($db,$sql);
  }  
  
  function HKOD_LIST($db, $par){
	$sql = "SELECT * FROM PDA_HKOD_LIST('".$par[0]."')";
	echo query_print($db,$sql);
  }  
  function CEGVAL_LIST($db, $par){
	$sql = "SELECT * FROM PDA_BEVET_CEGLIST";
	echo query_print($db,$sql);
  }  
  function LOGIN_KEZELOLIST($db, $par){
	$sql = "SELECT * FROM PDA_LOGIN_KEZELOLIST";
	echo query_print($db,$sql);
  }  
  
  function LOGIN_B1CLICK($db, $par) {
	$sql = "SELECT * FROM PDA_LOGIN('".$par[0]."')";
	echo query_print($db,$sql);
  }
  
    function MENU_PANELINIT($db, $par) {
	$sql = "SELECT * FROM PDA_MENU_PANELINIT('".$par[0]."')";
	echo query_print($db,$sql);
  }
    
  function LELTAR_MENTES($db, $par) {
	$sql = "SELECT * FROM PDA_LELTAR_MENTES('".$par[0]."','".$par[1]."','".$par[2]."','".$par[3]."','".$par[4]."','".$par[5]."')";
	echo query_print($db,$sql);
  }
  
  function LELTAR_CLOSE_UPD($db, $par) {
	$sql = "SELECT * FROM PDA_LELTAR_LEZARAS_UPD('".$par[0]."')";
	echo query_print($db,$sql);
  }
  
  function ORZOTT_LIST($db, $par){
	$sql = "SELECT * FROM PDA_ORZOTT_LIST('".$par[0]."','".$par[1]."')";
	echo query_print($db,$sql);
  } 
  	
  function ORZLELTAR_MENTES($db, $par) {
	$sql = "SELECT * FROM PDA_ORZOTTLELTAR_MENTES('".$par[0]."','".$par[1]."','".$par[2]."','".$par[3]."')";
	echo query_print($db,$sql);
  }
  
  function ORZLELTAR_CLOSE_UPD($db, $par) {
	$sql = "SELECT * FROM PDA_ORZOTTLELTAR_LEZARAS_UPD('".$par[0]."')";
	echo query_print($db,$sql);
  }	

  function BEVET_BCODE1_UPD($db, $par) {
	$sql = "SELECT * FROM PDA_BEVET_BCODE1_UPD('".$par[0]."','".$par[1]."','".$par[2]."','".$par[3]."','".$par[4]."','".$par[5]."')";
	echo query_print($db,$sql);
  }

  function BEVET_CIKKMENT_UPD($db, $par) {
	$sql = "SELECT * FROM PDA_BEVET_CIKKMENT_UPD('".$par[0]."','".$par[1]."','".$par[2]."','".$par[3]."','".$par[4]."')";
	echo query_print($db,$sql);
  }
  function BEVET_CLOSE_UPD($db, $par) {
	$sql = "SELECT * FROM PDA_BEVET_LEZARAS_UPD('".$par[0]."','".$par[1]."','".$par[2]."','".$par[3]."')";
	echo query_print($db,$sql);
  }  
  function HKOD_CLOSE_UPD($db, $par) {
	$sql = "SELECT * FROM PDA_HKOD_LEZARAS_UPD('".$par[0]."','".$par[1]."','".$par[2]."')";
	echo query_print($db,$sql);
  }
  
  function HKOD_MENTES($db, $par) {  
	$sql = "SELECT * FROM PDA_HKOD_MENTES('".$par[0]."','".$par[1]."','".$par[2]."','".$par[3]."','".$par[4]."','".$par[5]."')";
	echo query_print($db,$sql);
  }
  function HKOD_MENTES2($db, $par) {  
	
	$par = parsing($par);
	$sql = "SELECT * FROM PDA_HKOD_MENTES2".$par;
	echo query_print($db,$sql);
  }
  function KIADAS_BCODE2_UPD($db, $par) {
	$sql = "SELECT * FROM PDA_KIADAS_BCODE2_UPD('".$par[0]."','".$par[1]."','".$par[2]."','".$par[3]."','".$par[4]."')";
	echo query_print($db,$sql);
  }  
  
  function KIADAS_CLOSE_UPD($db, $par) {
	$sql = "SELECT * FROM PDA_KIADAS_LEZARAS_UPD('".$par[0]."','".$par[1]."')";
	echo query_print($db,$sql);
  }  
  
  
  function mantis_status_get($db){
	$sql="select value from mantis_config_table where config_id='status_enum_workflow'";
	$stmt = $db->query($sql);
	$row = $stmt->fetch(PDO::FETCH_ASSOC);
	$line = '';
	foreach ($row as $k => $v) {
		$status = unserialize(utf8_decode($v));
	}
	$stat=array();
	foreach ($status as $k => $v){
		$a=explode(',', $v);
		foreach ($a as $val){
		    $c=explode(':',$val);
			$d=array($c[0]=>$c[1]);
			if (in_array($c[0],$stat)!==true) $stat[$c[0]]=$c[1];
		}
	}
	return $stat;	

  }
  
  function mantis_details($db,$par){
	$sql=" select  mantis_project_table.name as cegnev,mantis_bug_table.fixed_in_version as honap, mantis_user_table.username as csopnev, REPLACE(mantis_bug_table.summary,'\r\n','<enter>')  as summary, REPLACE(mantis_bug_text_table.description,'\r\n','<enter>')  as description, ";
	$sql.="  REPLACE(mantis_bug_text_table.additional_information,'\r\n','<enter>') as megoldas,mantis_bug_table.last_updated as lastupdated";
	$sql.=" from mantis_bug_table ";
	$sql.=" left join mantis_user_table on mantis_bug_table.handler_id = mantis_user_table.id ";
	$sql.=" left join mantis_project_table on mantis_bug_table.project_id = mantis_project_table.id ";
	$sql.=" left join mantis_bug_text_table on mantis_bug_table.bug_text_id = mantis_bug_text_table.id ";
	$sql.=" where mantis_bug_table.id =".$par[0];
	echo mysql_query_print($db, $sql);
  }
  
  function mantis_summary($db,$par){
	$status = mantis_status_get($db);
	$sql=" select concat(mantis_bug_table.id,'@@style:mcolid') as kod,  ";
	$sql.=" concat(mantis_project_table.name,'@@style:mcolceg;rowstyle') as cegnev, ";
	$sql.=" 	case when coalesce(mantis_bug_table.fixed_in_version,'')<>''
	   then	CONCAT(mantis_bug_table.fixed_in_version,'@@style:mcolversion;rowstyle') 
		else	CONCAT(' ','@@style:mcolversion;rowstyle') 
		end
		as honap,  
    ";
	$sql.=" case when coalesce(mantis_user_table.username,'')<>'' then concat(mantis_user_table.username,'@@style:mcoluser;rowstyle') else concat(' ','@@style:mcoluser;rowstyle') end as csopnev, ";
	$sql.=" concat(mantis_bug_table.summary,'@@style:mcoldesc;rowstyle') as nev, ";
	$sql.=" concat(mantis_bug_table.status,'@@style:mcolstatus;rowstyle') as status, ";
	$sql.=" concat('[',(select count(mantis_bugnote_table.id) from mantis_bugnote_table where mantis_bug_table.id = mantis_bugnote_table.bug_id),']@@style:mcolnotecount;rowstyle') as notecount";
	$sql.=" from mantis_bug_table ";
	$sql.=" left join mantis_user_table on mantis_bug_table.handler_id = mantis_user_table.id ";
	$sql.="left join mantis_project_table on mantis_bug_table.project_id = mantis_project_table.id ";
	$sql .=" order by last_updated desc limit ".$par[0];
	$q=_mysql_query($db, $sql);
	foreach($q as $ix =>$val){
		$s = explode('@@',$val['status']);
		$statnev = $status[$s[0]];
		
		$style='@@style:rowstyledefault';
		if ($statnev=='kiosztva' || $statnev=='megoldva' ) $rowstyle='rowstyle'.$statnev; 
		if (utf8_encode($statnev)=='lezárva') $rowstyle='rowstylelezarva'; 
		if (utf8_encode($statnev)=='új') $rowstyle='rowstyleuj'; 
		$q[$ix]['statusbg']=' '.$style.';'.$rowstyle;

		foreach($q[$ix] as $mx =>$field){	
			$q[$ix][$mx]=str_replace('rowstyle',$rowstyle,$q[$ix][$mx]);
		}
		
		$style='@@style:mcolstatdef';
		if ($statnev=='kiosztva' || $statnev=='megoldva' ) $style='@@style:mcolstat'.$statnev; 
		if (utf8_encode($statnev)=='lezárva') $style='@@style:mcolstatlezarva'; 
		if (utf8_encode($statnev)=='új') $style='@@style:mcolstatuj'; 
		$q[$ix]['statustext']=utf8_encode($statnev).$style;

		$style='@@style:rowstyledefault';
		$q[$ix]['statusbg']=' '.$style.';'.$rowstyle;

	}
	echo response_print($q);
  }

  function mantis_item_notes($db,$par){
	$sql="select REPLACE(REPLACE(concat(concat(concat(cast(mantis_bugnote_table.last_modified as char(20)),'<enter>'),mantis_bugnote_text_table.note),'@@style:mcoldefault;rowstylemegoldva'),'\n','<enter>'),'\r','') as note from  mantis_bugnote_table left join mantis_bugnote_text_table on mantis_bugnote_text_table.id=mantis_bugnote_table.bugnote_text_id where bug_id=".$par[0]." order by date_submitted";
	 // logol($sql);
	$q=_mysql_query($db, $sql);
	$r = response_print($q);
	// echo "<pre>";
	// var_dump($r);
	echo $r ;
  }
  
?>