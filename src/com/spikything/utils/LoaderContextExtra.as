package com.spikything.utils
{
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;

	public class LoaderContextExtra extends LoaderContext
	{
		public function LoaderContextExtra(checkPolicyFile:Boolean = false, applicationDomain:ApplicationDomain = null, securityDomain:SecurityDomain= null)
		{
			this.checkPolicyFile = true;
			this.applicationDomain = ApplicationDomain.currentDomain;
			this.securityDomain = SecurityDomain.currentDomain;
			
			super(checkPolicyFile,applicationDomain,securityDomain);
		}
	}
}