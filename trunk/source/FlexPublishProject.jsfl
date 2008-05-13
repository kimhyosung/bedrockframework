fl.outputPanel.clear()
try{
	var objProject = fl.getProject()
	var bolSucceeded
	if (objProject.canPublishProject()) { 
	   bolSucceeded = objProject.publishProject(); 
	}else{
		bolSucceeded = false;
	}
	if (bolSucceeded) { 
		var objDefaultItem = objProject.defaultItem
		if(objDefaultItem.canPublish()){
			objDefaultItem.test()
		}else{
			fl.trace("\nCould not publish default document!\n")
		}
		fl.outputPanel.clear()
		fl.trace("\nPublished project successfully!\n")
	}else{
		fl.outputPanel.clear()
		fl.trace("\nCould not publish project!!\n")
	}
}catch($error){
	fl.trace("No project open!")
}
		






