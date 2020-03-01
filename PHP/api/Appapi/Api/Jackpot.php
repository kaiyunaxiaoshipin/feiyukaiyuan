<?php

class Api_Jackpot extends PhalApi_Api {

	public function getRules() {
		return array(
		);
	}
	

	/**
	 * 引导页
	 * @desc 用于 获取引导页信息
	 * @return int code 操作码，0表示成功
	 * @return array info 
	 * @return string info[0].total 总额
	 * @return string info[0].level 等级
	 * @return string msg 提示信息
	 */
	public function getJackpot() {
		$rs = array('code' => 0, 'msg' => '', 'info' => array());
		
		

		$info = getJackpotInfo();

		unset($info['id']);
		$rs['info'][0]=$info;
		return $rs;			
	}		
	

}
