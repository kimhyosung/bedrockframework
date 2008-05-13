fl.outputPanel.clear()

try{
	var objDocument = fl.getDocumentDOM()
	var strFileName = objDocument.name
	objDocument.testMovie()
	fl.trace("Published successfully!\n")
}catch($error){
	fl.trace("Could not publish!\n")
}