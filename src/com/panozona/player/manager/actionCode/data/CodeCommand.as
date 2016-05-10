package com.panozona.player.manager.actionCode.data
{
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-26 上午10:42:45
	 * 功能描述:
	 */
	public class CodeCommand
	{
		
		public var spaceId:String;
		
		public var funName:String;
		
		public var args:String;
		
		public var owner:String;
		
		public function CodeCommand(spaceId:String,funName:String,args:String,owner:String=null)
		{
			this.spaceId = spaceId;
			this.funName = funName;
			this.args = args;
			this.owner = owner;
		}
	}
}