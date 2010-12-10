	/*
	Variable Declarations
	*/
	
	function initializeBedrockPanel()
	{
		fl.outputPanel.clear();
		fl.outputPanel.trace( "Bedrock Panel | Version 2.0.0" );
		fl.outputPanel.trace( "" );
	}
	function getConstants()
	{
		var constantsObj = new Object;
		constantsObj.bedrockPath = fl.configURI + "Bedrock Framework/";
		constantsObj.settingsPath = constantsObj.bedrockPath + "settings.bedrock";
		constantsObj.versionsPath = constantsObj.bedrockPath + "versions/";
		constantsObj.baseIDEClassPath = "$(LocalData)/Bedrock Framework/versions/bedrock";
		constantsObj.frameworkSourceFolder = "source/";
		constantsObj.projectSourceFolder = "source/";
		constantsObj.projectDeployFolder = "wwwroot/";
		return constantsObj;
	}
	function getSelectedProjectPanelPath( $projectXML )
	{
		var project = convertProject( $projectXML );
		return project.selectedFrameworkProjectPanelPath;
	}
	function getSelectedResourceBundle( $projectXML )
	{
		var project = convertProject( $projectXML );
		return openFile( project.selectedFrameworkResourcePath );
	}
	
	function convertProject( $data )
	{
		var constants = getConstants();
		var projectXML = new XML( unescape( $data ) );
		
		var projectObj = new Object;
		for each( var item in projectXML.children() ) {
			if ( item.name() != "flas" ) projectObj[ item.name() ] = sanitize( item.toString() );
			if ( item.name() == "frameworkVersion" ) projectObj[ item.name() ] = item.toString();
		}
		projectObj.assetsPath = projectObj.path + projectObj.assetsFolder;
		projectObj.sourcePath = projectObj.path + projectObj.sourceFolder;
		projectObj.deployPath = projectObj.path + projectObj.deployFolder;
		projectObj.projectFilePath = projectObj.path + "project.bedrock";
		projectObj.projectFrameworkPath = projectObj.sourcePath + "com/bedrock/";
		projectObj.shellPath = projectObj.sourcePath + "shell.fla";
		projectObj.configPath = projectObj.deployPath + "bedrock_config.xml";
		projectObj.tempClassPath = projectObj.sourcePath + "__template/";
		projectObj.rootPackagePath = projectObj.sourcePath + projectObj.rootPackage.toString().split(".").join( "/" ) + "/";
		projectObj.viewPackage = projectObj.rootPackage + ".view";
		projectObj.publishProfilePath = projectObj.sourcePath + "profile.bedrock";
		projectObj.bedrockprojectObjPath = projectObj.sourcePath + "project.bedrock";
		
		projectObj.selectedFrameworkPath = constants.versionsPath + "bedrock" + projectObj.frameworkVersion + "/";
		projectObj.selectedFrameworkProjectPanelPath = projectObj.selectedFrameworkPath + "BedrockProjectPanel.swf";
		projectObj.selectedFrameworkResourcePath = projectObj.selectedFrameworkPath + "resources.bedrock";
		projectObj.selectedFrameworkSourcePath = projectObj.selectedFrameworkPath + "source/"; 
		projectObj.selectedFrameworkBedrockPath = projectObj.selectedFrameworkSourcePath + "com/bedrock/"; 
		projectObj.selectedFrameworkSamplesPath = projectObj.selectedFrameworkPath + "samples/";
		projectObj.selectedFrameworkTemplatePath = projectObj.selectedFrameworkPath + "templates/";
		projectObj.selectedFrameworkClassTemplatePath = projectObj.selectedFrameworkTemplatePath + "classes/";
		projectObj.selectedTemplatePath = projectObj.selectedFrameworkTemplatePath + projectObj.template + "/";
		projectObj.selectedTemplateSourcePath = projectObj.selectedTemplatePath + constants.projectSourceFolder;
		projectObj.selectedTemplateDeployPath = projectObj.selectedTemplatePath + constants.projectDeployFolder;
		
		return projectObj;
	}
	
	/*
	Project Management
	*/
	function generateProject( $projectXML )
	{
		var project = convertProject( $projectXML );
		
		FLfile.createFolder( project.assetsPath );
		FLfile.createFolder( project.sourcePath );
		FLfile.createFolder( project.deployPath );
		
		copyFolder( project.selectedTemplateSourcePath, project.sourcePath );
		copyFolder( project.selectedTemplateDeployPath, project.deployPath );
		moveFolder( project.tempClassPath, project.rootPackagePath );
		
		changeASPackagePaths( project.rootPackagePath, project.rootPackage );
		copyFolder( project.selectedFrameworkSourcePath, project.sourcePath );
		updateFLAs( $projectXML );
		
		fl.openDocument( project.shellPath ).testMovie();
	}
	function updateProject( $projectXML, $switchFrameworkVersion )
	{
		var project = convertProject( $projectXML );
		if ( sanitizeBoolean(  $switchFrameworkVersion ) ) {
			FLfile.remove( project.projectFrameworkPath );
			copyFolder( project.selectedFrameworkBedrockPath, project.projectFrameworkPath );
		}
		updateFLAs( $projectXML );
		if ( project.publishFiles ) fl.openDocument( project.shellPath ).testMovie();
	}
	function updateFLAs( $projectXML )
	{
		var constants = getConstants();
		var project = convertProject( $projectXML );
		
		var arrFiles = FLfile.listFolder( project.sourcePath + "*.fla", "files" );
		var objDocument;
		var flaPath;
		
		for each( var filename in arrFiles ) {
		
			flaPath = project.sourcePath + filename;
			if ( FLfile.exists( flaPath ) ) {
				objDocument = fl.openDocument( flaPath );
				
				// Property Update
				objDocument.width = project.width;
				objDocument.height = project.height;
				objDocument.backgroundColor = project.stageColor;
				objDocument.frameRate = project.fps;
				
				// Linkage Update
				for each ( var item in objDocument.library.items ) {
					if ( item.linkageExportForAS ) item.linkageBaseClass = item.linkageBaseClass.split( "__template" ).join( project.rootPackage );
				}
				objDocument.docClass = objDocument.docClass.split( "__template" ).join( project.rootPackage );
				
				
				objDocument.exportPublishProfile( project.publishProfilePath );
				replaceStringInFile( project.publishProfilePath, constants.projectDeployFolder, project.deployFolder );
				objDocument.importPublishProfile( project.publishProfilePath );
				
				if ( project.publishFiles && filename != "shell.fla" ) {
					objDocument.exportSWF( getExportDestination( project.publishProfilePath, project.path ) );
				}
				
				objDocument.save();
				if ( filename != "shell.fla" ) objDocument.close();
			}
			
		}
		fl.closeAll();
	}
	function changeASPackagePaths($sourcePath, $packagePath)
	{
		var arrFiles = FLfile.listFolder( $sourcePath + "*.as", "files" );
		for each ( var fileName in arrFiles ) {
			replaceStringInFile( $sourcePath + fileName, "__template", $packagePath );
		}
		
		var arrFolders = FLfile.listFolder( $sourcePath, "directories" );
		for each ( var folderName in arrFolders ) {
			changeASPackagePaths( $sourcePath + folderName + "/", $packagePath );
		}
		
	}
	
	
	
	
	
	/*
	Copy Content
	*/
	function copyContent( $projectXML, $target, $source )
	{
		var project = convertProject( $projectXML );
		
		var xmlTarget = new XML( unescape( $target ) );
		var xmlSource = new XML( unescape( $source ) );
		
		var strSourceFLA = project.sourcePath + xmlSource.@id + ".fla";
		var strTargetFLA = project.sourcePath + xmlTarget.@id + ".fla";
		
		if ( FLfile.exists( strTargetFLA ) ) {
			FLfile.remove( strTargetFLA );
		}
		FLfile.copy( strSourceFLA, strTargetFLA );
		
		var objSourceFLA = fl.openDocument( strSourceFLA );
		var strSourceAS = project.sourcePath + objSourceFLA.docClass.split(".").join("/") +".as";
		var strSourceViewName = objSourceFLA.docClass.substring( ( objSourceFLA.docClass.lastIndexOf( "." ) + 1 ), objSourceFLA.docClass.length );
		objSourceFLA.exportPublishProfile( project.publishProfilePath );
		
		var strTargetViewName = getClassName( xmlTarget.@id ) + "View";
		var strTargetAS = project.sourcePath + project.viewPackage.split(".").join("/") + "/" + strTargetViewName + ".as";
		
		if ( FLfile.exists( strTargetAS ) ) {
			FLfile.remove( strTargetAS );
		}
		FLfile.copy( strSourceAS, strTargetAS );		
		replaceStringInFile( strTargetAS, strSourceViewName, strTargetViewName );
		
		
		var objTargetFLA = fl.openDocument( strTargetFLA );
		
		replaceStringInFile( project.publishProfilePath, xmlSource.@id, xmlTarget.@id );
		replaceStringInFile( project.publishProfilePath, objSourceFLA.docClass, ( project.viewPackage + "." + strTargetViewName ) );
		objTargetFLA.importPublishProfile( project.publishProfilePath );
		
		openScript( strTargetAS );
		
		objSourceFLA.close();
		objTargetFLA.save();
		objTargetFLA.testMovie();
	}
	
	
	function deleteContent( $projectXML, $details )
	{
		var project = convertProject( $projectXML );
		var detailsXML = new XML( unescape( $details ) );
		
		if ( sanitizeBoolean( detailsXML.deleteDocumentClass ) ) {
			var flaDocument =  fl.openDocument( project.sourcePath + detailsXML.@id.toString() + ".fla" );
			FLfile.remove( project.sourcePath + flaDocument.docClass.split(".").join("/") +".as" );
			flaDocument.close();
		}
		if ( sanitizeBoolean( detailsXML.deleteFLA ) ) {
			FLfile.remove( project.sourcePath + detailsXML.@id.toString() + ".fla" );
		}
		if ( sanitizeBoolean( detailsXML.deleteSWF ) ) {
			FLfile.remove( project.deployPath + "assets/swfs/" + detailsXML.@id.toString() + ".swf" );
		}
	}
	
	
	
	/*
	FLA Publishing
	*/
	function publishProject( $projectXML, $publishList )
	{
		var project = convertProject( $projectXML );
		
		var publishXML = new XML( unescape( $publishList ) );
		
		var shellXML;
		for each( var flaXML in publishXML..file ) {
			if ( flaXML.@name == "shell" || flaXML.@name == "shell.fla" ) {
				shellXML = flaXML;
			} else {
				exportSWF( $projectXML, flaXML );
			}
		}
		exportSWF( $projectXML, shellXML );
	}
	function exportSWF( $projectXML, $fla )
	{
		var project = convertProject( $projectXML );
		
		var xmlFLA;
		switch( typeof( $fla ) ) {
			case "xml" :
				xmlFLA = $fla;
				break;
			case "string" :
				xmlFLA = new XML( unescape( $fla ) );
				break;
		}
		
		var objDocument;
		if ( FLfile.exists( project.path + xmlFLA.@path ) ) {
				xmlFLA.@open = ( fl.findDocumentIndex( xmlFLA.@name + xmlFLA.@type ) != "" );
				objDocument = fl.openDocument( project.path + xmlFLA.@path );
				
				objDocument.exportPublishProfile( project.publishProfilePath );
				
				if ( xmlFLA.@name != "shell" ) {
					objDocument.exportSWF( getExportDestination( project.publishProfilePath, project.path ) );
				} else {
					objDocument.testMovie();
				}
				if ( !sanitizeBoolean( xmlFLA.@open ) && xmlFLA.@name != "shell" ) objDocument.close();
			}
	}
	function getExportDestination( $profilePath, $projectPath )
	{
		var strProfile = openFile( $profilePath );
		var numFrom = strProfile.indexOf( "<flashFileName>" );
		numFrom += new String( "<flashFileName>" ).length;
		var strDestination = strProfile.substring( numFrom, strProfile.indexOf("</flashFileName>") );
		strDestination = strDestination.replace( "../", $projectPath );
		return strDestination;
	}
	
	
	
	
	
	
	
	
	
	/*
	Version Functions
	*/
	function changeBedrockClassPath( $frameworkVersion )
	{
		var constants = getConstants();
		var bolFound = false;
		
		var arrPaths = fl.as3PackagePaths.split(";");
		var strFrameworkPath = constants.baseIDEClassPath + $frameworkVersion + "/" + constants.frameworkSourceFolder;
		
		for ( var i in arrPaths) {
			if (arrPaths[i].indexOf("bedrock") != -1){
				arrPaths[i] = strFrameworkPath;
				bolFound = true;
			}
		}
		if ( !bolFound  ) arrPaths.unshift( strFrameworkPath );
		fl.as3PackagePaths = arrPaths.join( ";" );
	}
	function deleteBedrockClassPath()
	{
		var arrPaths = fl.as3PackagePaths.split(";");
		for ( var i in arrPaths) {
			if (arrPaths[i].indexOf("bedrock") != -1) {
				arrPaths.splice( i,1 );
			}
		}
		fl.as3PackagePaths = arrPaths.join( ";" );
	}
	function getBedrockVersions()
	{
		var constants = getConstants();
		var arrVersions = FLfile.listFolder( constants.versionsPath, "directories");
		arrVersions.reverse();

		for (var i = 0; i < arrVersions.length; i++) {
			arrVersions[i] = arrVersions[i].split("bedrock").join("");
		}
		return arrVersions;
	}
	
	
	
	
	
	
	
	
	/*
	Class Generation
	*/
	function generateClasses( $projectXML, $data )
	{
		var project = convertProject( $projectXML );
		var xmlData = new XML( unescape( $data ) );
		for each( var xmlFile in xmlData.files..file ) {
			generateClass( project.selectedFrameworkClassTemplatePath, xmlFile, sanitizeBoolean( xmlData.@openClasses ) );
		}
	}
	function generateClass( $templatePath, $data, $openClasses )
	{
		var xmlData = new XML( $data );
		var strLocation = $templatePath + $data.@template;
		
		var strDestination = xmlData.@destination;
		if ( !FLfile.exists( strDestination ) ) {
			FLfile.createFolder( strDestination );
		}
		
		strDestination += xmlData.@className + ".as"
		if ( FLfile.exists( strDestination ) ) {
			FLfile.remove( strDestination );
		}
		FLfile.copy( strLocation, strDestination );
		
		replaceStringInFile( strDestination, "%%classPackage%%", xmlData.@classPackage );
		replaceStringInFile( strDestination, "%%className%%", xmlData.@className );
		
		
		if ( $openClasses ) {
			openScript( strDestination );
		}
	}
	
	
	
	
	
	
	
	/*
	Samples
	*/
	function getSampleFolders( $projectXML )
	{
		var project = convertProject( $projectXML );
		
		var xmlData = new XML( <samples/> );
		var arrFolders = FLfile.listFolder( project.selectedFrameworkSamplesPath, "directories" );		
		for each( var folderName in arrFolders ) {
			xmlData.appendChild( getSampleXML( project.selectedFrameworkSamplesPath, folderName ) )
		}
		
		return escape( xmlData.toXMLString() );
	}
	function getSampleXML( $samplePath, $name )
	{
		var xmlSample = new XML( <sample/> );
		xmlSample.@name = $name;
		xmlSample.@path = $samplePath + xmlSample.@name + "/";
		return xmlSample;
	}
	function loadSample( $data )
	{
		var xmlData = new XML( unescape( $data ) );
		xmlData.detail = openFile( xmlData.@path + "sample.bedrock" );
		xmlData.preview = xmlData.@path + "test.swf";
		xmlData.code = openFile( xmlData.@path + "TestDocument.as" );
		
		return escape( xmlData.toXMLString() );
	}
	
	
	
	function getTemplates( $project )
	{
		var project = convertProject( $project );
		var folders = FLfile.listFolder( project.selectedFrameworkTemplatePath, "directories" );
		return escape( folders.toString() );
	}
	
	
	/*
	Get Project Folder Contents
	*/
	function refreshProjectStructure( $path, $includeSubFolders )
	{
		var strLocation = unescape( $path );
		var xmlContents = getFoldersAsXML( strLocation, new XML( <files/> ), sanitize( $includeSubFolders ) );
		return escape( xmlContents.toXMLString() );
	}
	
	
	
	
	
	function openConfig( $projectXML )
	{
		var project = convertProject( $projectXML );
		if ( FLfile.exists ( project.configPath ) ) {
			return FLfile.read( project.configPath );
		} else {
			return new String;
		}
	}
	function saveConfig( $projectXML, $content )
	{
		var project = convertProject( $projectXML );
		FLfile.write( project.configPath, unescape( $content ) );
	}
	
	function saveProjectFile( $projectXML )
	{
		var project = convertProject( $projectXML );
		FLfile.write( project.projectFilePath, unescape( $projectXML ) );
	}
	
	
	/*
	Tracing
	*/
	function output( $trace )
	{
		fl.outputPanel.trace( unescape( $trace ) );
	}
	/*
	Selection Operations
	*/
	function selectProjectFolder()
	{
		return fl.browseForFolderURL("Select a new Bedrock Project folder");
	}
	function selectProjectFile()
	{
		var strLocation = fl.browseForFileURL("select", "Select a project.bedrock file");
		if ( strLocation != null && strLocation.indexOf( "project.bedrock" ) != -1 ) {
			return strLocation;
		} else {
			return "";
		}
	}
	/*
	File Operations
	*/
	function openFile( $path )
	{
		var strLocation = unescape( $path );
		if ( FLfile.exists ( strLocation ) ) {
			return FLfile.read( strLocation );
		} else {
			return new String;
		}
	}
	function openRelativeFile( $name ) 
	{
		var constants = getConstants();
		var strLocation = constants.bedrockPath + $name;
		if ( FLfile.exists( strLocation ) ) {
			return FLfile.read( strLocation );
		} else {
			return new String;
		}
	}
	function openFLA( $path )
	{
		return fl.openDocument( unescape( $path ) );
	}
	function openScript( $path )
	{
		return fl.openScript( unescape( $path ) );
	}
	function fileExists( $path )
	{
		return FLfile.exists( unescape( $path ) );
	}
	/*
	Save Operations
	*/
	function saveSettingsFile( $content )
	{
		var constants = getConstants();
		FLfile.write( constants.settingsPath, unescape( $content ) );
	}
	function saveFile( $path, $content )
	{
		FLfile.write( unescape( $path ), unescape( $content ) );
	}
	function deleteFile( $path )
	{
		FLfile.remove( unescape( $path ) );
	}
	
	function copyFolder( $sourcePath, $targetPath )
	{
		FLfile.createFolder( $targetPath );
		
		var files = FLfile.listFolder( $sourcePath, "files" );
		for each ( fileName in files ) {
			FLfile.copy( $sourcePath + fileName, $targetPath + fileName );
		}
		
		var folders = FLfile.listFolder( $sourcePath, "directories" );
		for each ( folderName in folders ) {
			copyFolder( $sourcePath + folderName + "/", $targetPath + folderName + "/" );
		}
	}
	function moveFolder($sourcePath, $targetPath)
	{
		copyFolder( $sourcePath, $targetPath );
		FLfile.remove($sourcePath);
	}
	/*
	XML File Handling
	*/
	function getFoldersAsXML( $sourcePath, $parentXML, $includeSubFolders )
	{
		if ( $includeSubFolders ) {
			var arrFolders = FLfile.listFolder( $sourcePath, "directories" );
			for each ( var folderName in arrFolders ) {
				var xmlFolder = new XML( <file name={ folderName } type="folder" /> );
				getFoldersAsXML( $sourcePath + folderName + "/", xmlFolder, $includeSubFolders );
				$parentXML.appendChild( xmlFolder );
			}
		}
		getFilesAsXML( $sourcePath, $parentXML);
		return $parentXML;
	}
	function getFilesAsXML( $sourcePath, $parentXML )
	{
		var arrFiles = FLfile.listFolder( $sourcePath, "files" );
		var strName;		
		var strExtension;
		for each(  var fileName in arrFiles ) {
			strName = fileName.substring( 0, fileName.lastIndexOf( "." ) );
			strExtension = fileName.substring( fileName.lastIndexOf( "." ), fileName.length );
			if ( strName == "" ) strName = fileName;
			 $parentXML.appendChild( <file name={ strName } path={ $sourcePath + fileName } type={  strExtension }  /> );
		}
	}
	/*
	Sanitize Variables
	*/
	function sanitize( $value )
	{
		var strValue = $value;
			
		if (strValue == "") return "";
		if (strValue == "null") return null;

		var numValue = parseInt(strValue);
		if ( !isNaN(numValue) ) return numValue;
		
		if ( sanitizeBoolean(strValue) != null ) return sanitizeBoolean(strValue);
		
		return strValue;
	}
	function sanitizeBoolean( $boolean )
	{
		if ( $boolean == null ) return null;
		var strBoolean =  $boolean.toLowerCase();
		if (strBoolean != "true" && strBoolean != "false") {
			return null;
		} else {
			return (strBoolean == "true") ? true:false;
		}
	}
	/*
	String Functions
	*/
	function capitalize( $text )
	{
		var strFirst = $text.charAt( 0 ).toUpperCase();
		var strRest = ( $text.substring( 1, $text.length ) );
		return strFirst + strRest;
	}
	function getClassName( $text )
	{
		var strClassName = new String();
		var arrWords = new String( $text ).split("_");
		for each ( var strWord in arrWords ) {
			strClassName += capitalize( strWord );
		}
		return strClassName;
	}
	function replaceStringInFile( $file, $flag, $text )
	{
		if ( FLfile.exists( $file ) ) {
			var strContent = FLfile.read($file);
			if ( strContent ) {
				var strEdited = strContent.split( $flag ).join( $text );
				FLfile.remove($file);
				FLfile.write( $file, strEdited );
			}
		}
	}