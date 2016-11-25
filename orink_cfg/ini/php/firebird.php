<?php
class Firebird {
	private static $link = null ;
	
	private static function getLink(){
		if (self::$link) return self::$link;

		$driver="firebird";
		$user="SYSDBA";
		$password="masterkey";
        $host="192.168.1.105";
		$dbname_depo="F:\ALFA\TIR\DAT\DEPO12\DEPO12.GDB" ;
        $dbname_orink="F:\ALFA\TIR\DAT\ORINK\ORINKMUNKA.GDB" ;
        $dbname=$dbname_orink;
		//$host="192.168.1.6";
		//$dbname="I:\\alfa\\tir\\dat\\depo16\\DEPO16.GDB" ;

		$port="3050";
		
        		
		
		$dsn = "${driver}:";
		$dsn .= 'dbname='.$host.':'.$dbname;
		$options=array();
		
		self::$link = new PDO($dsn, $user, $password, $options);
		$attributes = array();
		foreach ($attributes as $k => $v)
			self::$link->setAttribute(constant("PDO::{$k}"), constant( "PDO::{$v}" ));
		return self :: $link ;
	}

	/**
	 * Statikus PDO oszt�lyh�v�sok
	 * @param string $name
	 * @param string $args
	 * @return PDO
	 */
	public static function __callStatic($name, $args){
		$callback = array(self::getLink(), $name);
		return call_user_func_array($callback, $args);
	}
	
	public static function prepare($sql){
		return self::getLink()->prepare($sql);
	}

}
?>