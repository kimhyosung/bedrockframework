	
	function initializeBedrockPanel()
	{
		fl.outputPanel.clear();
		fl.outputPanel.trace( "Bedrock Panel | Version 2.1.1" );
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

		projectObj.structure = new Array();
		var projectPathObj;
		for each ( var pathXML in projectXML.structure..path ) {
			projectPathObj = getAttributesAsObject( pathXML );
			projectPathObj.path = projectObj.path + projectPathObj.folder;
			projectObj.structure.push( projectPathObj );
			if ( projectPathObj.id == "sourcePath" ) projectObj.sourcePath = projectPathObj.path;
			if ( projectPathObj.id == "deployPath" ) projectObj.deployPath = projectPathObj.path;
			if ( projectPathObj.id == "configPath" ) {
				projectObj.configPath = projectPathObj.path + "bedrock_config.xml";
			}
			if ( projectPathObj.id == "swfsPath" ) {
				projectObj.swfsPath = projectPathObj.path;
				projectObj.swfsFolder = projectPathObj.folder;
			}
		}
		
		projectObj.swcPath = projectObj.sourcePath + "BedrockFramework" + projectObj.frameworkVersion + ".swc"; 
		
		projectObj.projectFilePath = projectObj.path + "project.bedrock";
		projectObj.projectFrameworkPath = projectObj.sourcePath + "com/bedrock/";
		projectObj.shellPath = projectObj.sourcePath + "shell.fla";
		projectObj.tempClassPath = projectObj.sourcePath + "__template/";
		projectObj.rootPackagePath = projectObj.sourcePath + projectObj.rootPackage.toString().split(".").join( "/" ) + "/";
		projectObj.viewPackage = projectObj.rootPackage + ".view";
		projectObj.publishProfilePath = projectObj.sourcePath + "profile.bedrock";
		projectObj.bedrockProjectPath = projectObj.sourcePath + "project.bedrock";
		
		projectObj.selectedFrameworkPath = constants.versionsPath + "bedrock" + projectObj.frameworkVersion + "/";
		projectObj.selectedFrameworkProjectPanelPath = projectObj.selectedFrameworkPath + "BedrockProjectPanel.swf";
		projectObj.selectedFrameworkResourcePath = projectObj.selectedFrameworkPath + "resources.bedrock";
		projectObj.selectedFrameworkSourcePath = projectObj.selectedFrameworkPath + "source/"; 
		projectObj.selectedFrameworkSWCPath = projectObj.selectedFrameworkPath + "BedrockFramework" + projectObj.frameworkVersion + ".swc"; 
		projectObj.selectedFrameworkBedrockPath = projectObj.selectedFrameworkSourcePath + "com/bedrock/"; 
		projectObj.selectedFrameworkSamplesPath = projectObj.selectedFrameworkPath + "samples/";
		projectObj.selectedFrameworkTemplatePath = projectObj.selectedFrameworkPath + "templates/";
		projectObj.selectedFrameworkClassTemplatePath = projectObj.selectedFrameworkTemplatePath + "classes/";
		projectObj.selectedFrameworkSpecialAssetTemplatePath = projectObj.selectedFrameworkTemplatePath + "specialAssets/";
				
		return projectObj;
	}
	function convertTemplate( $data )
	{
		var templateXML = new XML( unescape( $data ) )
		var templateObj = getNodesAsObject( templateXML );
		
		templateObj.structure = new Array();
		var templatePathObj;
		for each ( var pathXML in templateXML.structure..path ) {
			templatePathObj = getAttributesAsObject( pathXML );
			templatePathObj.path = templateObj.path + templatePathObj.folder;
			templateObj.structure.push( templatePathObj );
			if ( templatePathObj.id == "sourcePath" ) templateObj.sourcePath = templatePathObj.path;
			if ( templatePathObj.id == "configPath" ) templateObj.configPath = templatePathObj.path + "bedrock_config.xml";
		}
				
		return templateObj;
	}
	function convertAsset( $data )
	{
		return getAttributesAsObject( new XML( unescape( $data ) ) );
	}
	/*
	Project Management
	*/
	function generateProject( $projectXML, $templateXML )
	{
		var project = convertProject( $projectXML );
		var template = convertTemplate( $templateXML );
		
		for each ( var pathObj in project.structure ) {
			FLfile.createFolder( pathObj.path );
		}
		
		copyFolder( template.sourcePath, project.sourcePath );
		
		var length = project.structure.length;
		var projectPathObj;
		var templatePathObj;
		for ( var i = 0; i < length; i++ ) {
			projectPathObj = project.structure[ i ];
			templatePathObj = template.structure[ i ];
			if ( projectPathObj.id != "sourcePath" && projectPathObj.id != "configPath" ) copyFiles( templatePathObj.path, projectPathObj.path );
		}
		
		var configPaths = findFiles( project.path, "bedrock_config.xml" );
		for each ( var path in configPaths ) {
			FLfile.remove( path );
		}
		FLfile.copy( template.configPath, project.configPath );
		moveFolder( project.tempClassPath, project.rootPackagePath );
		
		changeASPackagePaths( project.rootPackagePath, project.rootPackage );
		
		switch (  project.frameworkCopy ) {
			case "source" :
				copyFolder( project.selectedFrameworkSourcePath, project.sourcePath );
				break;
			case "swc" :
				FLfile.copy( project.selectedFrameworkSWCPath, project.swcPath );
				break;
		}
		
		generateFLAs( $projectXML, $templateXML );
		
		fl.openDocument( project.shellPath );
		//fl.openDocument( project.shellPath ).testMovie();
	}
	function updateProject( $projectXML, $switchFrameworkVersion )
	{
		var project = convertProject( $projectXML );
		if ( sanitizeBoolean(  $switchFrameworkVersion ) ) {
			/*
			Add some functionality here
			*/
		}
		var arrFiles = FLfile.listFolder( project.sourcePath + "*.fla", "files" );
		var objDocument;
		var flaPath;
		
		for each( var filename in arrFiles ) {
			objDocument = fl.openDocument( project.sourcePath + filename );
			updateFLAProperties( objDocument, project );
			objDocument.save();
			objDocument.close();
		}
		//if ( project.publishFiles ) fl.openDocument( project.shellPath ).testMovie();
	}
	function generateFLAs( $projectXML, $templateXML )
	{
		var constants = getConstants();
		var project = convertProject( $projectXML );
		var template = convertTemplate( $templateXML );
		
		var arrFiles = FLfile.listFolder( project.sourcePath + "*.fla", "files" );
		var objDocument;
		var flaPath;
		
		for each( var filename in arrFiles ) {
		
			flaPath = project.sourcePath + filename;
			if ( FLfile.exists( flaPath ) ) {
				
				objDocument = fl.openDocument( flaPath );
				updateFLAProperties( objDocument, project );
				// Linkage Update
				for each ( var item in objDocument.library.items ) {
					if ( item.linkageExportForAS ) item.linkageBaseClass = item.linkageBaseClass.split( "__template" ).join( project.rootPackage );
				}
				objDocument.docClass = objDocument.docClass.split( "__template" ).join( project.rootPackage );
				
				if ( template.editableStructure ) {
					objDocument.exportPublishProfile( project.publishProfilePath );
					replaceStringInFile( project.publishProfilePath, getNodeValueInFile( project.publishProfilePath, "flashFileName" ), getFinalDestnation( $projectXML, filename ) );
					objDocument.importPublishProfile( project.publishProfilePath );
					FLfile.remove( project.publishProfilePath );
				}
				
				objDocument.save();
				if ( filename != "shell.fla" ) objDocument.close();
			}
			
		}
		fl.closeAll();
	}
	function updateFLAProperties( $document, $project )
	{
		// Property Update
		$document.width = $project.width;
		$document.height = $project.height;
		$document.backgroundColor = $project.stageColor;
		$document.frameRate = $project.fps;
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
	
	function findFileAndGetSize( $projectXML, $filename )
	{
		var project = convertProject( $projectXML );
		var files = findFiles( project.deployPath, $filename )
		
		if ( files.length > 0 ) return FLfile.getSize( files[ 0 ] );
		return 0;
	}
	
	/*
	Copy Content
	*/
	function copyModule( $projectXML, $target, $source )
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
		
		FLfile.remove( project.publishProfilePath );
		
		openScript( strTargetAS );
		
		objSourceFLA.close();
		objTargetFLA.save();
		objTargetFLA.testMovie();
	}
	
	
	function deleteModule( $projectXML, $details )
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
			FLfile.remove( project.swfsPath + detailsXML.@id.toString() + ".swf" );
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
			if ( flaXML.@name != "shell" || flaXML.@name != "shell.fla" ) {
				exportSWF( $projectXML, flaXML );
			}
		}
	}
	function exportSWF( $projectXML, $fla )
	{
		var project = convertProject( $projectXML );
		
		var flaXML;
		switch( typeof( $fla ) ) {
			case "xml" :
				flaXML = $fla;
				break;
			case "string" :
				flaXML = new XML( unescape( $fla ) );
				break;
		}
		
		/*
		var objShell = fl.openDocument( project.shellPath );
		objShell.exportPublishProfile( project.publishProfilePath );
		
		var objDocument;
		*/
		
		if ( FLfile.exists( project.path + flaXML.@path ) ) {
				
				fl.trace( flaXML.toXMLString() );
				if ( flaXML.@name != "shell" && flaXML.@name != "shell.fla" ) {
					fl.publishDocument( project.path + flaXML.@path, "Default" );
				} else {
					fl.openDocument( project.shellPath ).testMovie();
				}
				
				
				/*
				flaXML.@open = ( fl.findDocumentIndex( flaXML.@name + flaXML.@type ) != "" );
				
				objDocument = fl.openDocument( project.path + flaXML.@path );
				objDocument.exportPublishProfile( project.publishProfilePath );
				
				if ( flaXML.@name != "shell" ) {
					objDocument.exportSWF( getExportDestination( project.publishProfilePath, project.path ) );
				} else {
					objDocument.testMovie();
				}
				FLfile.remove( project.publishProfilePath );
				
				if ( !sanitizeBoolean( flaXML.@open ) && flaXML.@name != "shell" ) objDocument.close();
				*/
				
				
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
	
	function getNodeValueInFile( $profilePath, $tag )
	{
		var strProfile = openFile( $profilePath );
		var numFrom = strProfile.indexOf( "<" + $tag + ">" );
		numFrom += new String( "<" + $tag + ">" ).length;
		return strProfile.substring( numFrom, strProfile.indexOf("</" + $tag + ">") );
	}
	function getFinalDestnation( $projectXML, $filename )
	{
		var project = convertProject( $projectXML );
		
		var sourcePath = project.sourcePath.split( project.path ).join( "" );
		var difference = sourcePath.split( "/" ).length;
		difference -= 1;
		
		var path = "";
		for ( var i = 0; i < difference; i++ ) {
			path += "../";
		}
		return ( path + project.swfsFolder + $filename.split( ".fla" ).join( ".swf" ) );
	}
	
	
	
	function generateSpecialAsset( $projectXML, $assetXML )
	{
		var project = convertProject( $projectXML );
		var asset = convertAsset( $assetXML );
		// reminder : have to do this later
		fl.trace( "WTF" );
		fl.trace( asset.id );
		var objDocument;
		switch( asset.id ) {
			case "library" :
				
				FLfile.copy( project.selectedFrameworkSpecialAssetTemplatePath + "LibraryBuilder.as", project.rootPackagePath + "LibraryBuilder.as" )
				replaceStringInFile( project.rootPackagePath + "LibraryBuilder.as", "__template", project.rootPackage );
				
				FLfile.copy( project.selectedFrameworkSpecialAssetTemplatePath + "library.fla", project.sourcePath + "library.fla" );
				objDocument = fl.openDocument( project.sourcePath + "library.fla" );
				objDocument.docClass = objDocument.docClass.split( "__template" ).join( project.rootPackage );
				objDocument.save();
				objDocument.close();
				break;
			case "fonts" :
				
				FLfile.copy( project.selectedFrameworkSpecialAssetTemplatePath + "FontBuilder.as", project.rootPackagePath + "FontBuilder.as" );
				replaceStringInFile( project.rootPackagePath + "FontBuilder.as", "__template", project.rootPackage );
				
				FLfile.copy( project.selectedFrameworkSpecialAssetTemplatePath + "fonts.fla", project.sourcePath + "fonts.fla" );
				objDocument = fl.openDocument( project.sourcePath + "fonts.fla" );
				objDocument.docClass = objDocument.docClass.split( "__template" ).join( project.rootPackage );
				objDocument.save();
				objDocument.close();
				break;
			case "resourceBundle" :
				FLfile.copy( project.selectedFrameworkSpecialAssetTemplatePath + "resourceBundle.xml", project.assetsPath + "xml/resource_bundle.xml" );
				break;
			case "stylesheet" :
				FLfile.copy( project.selectedFrameworkSpecialAssetTemplatePath + "flash_style.css", project.assetsPath + "stylesheet/flash_style.css" );
				break;
		}
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
	
	
	
	function getVersionTemplates( $project )
	{
		var templatesXML = new XML( <templates/> );
		var project = convertProject( $project );
		var folders = FLfile.listFolder( project.selectedFrameworkTemplatePath, "directories" );
		var path;
		for each( var folder in folders ) {
			path = project.selectedFrameworkTemplatePath + folder + "/template.bedrock";
			if ( FLfile.exists( path ) ) {
				templatesXML.appendChild( <template path={ path } /> );
			}
		}
		return escape( templatesXML.toXMLString() );
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
		if ( FLfile.exists( project.configPath ) ) {
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
	function selectTemplateFile()
	{
		var strLocation = fl.browseForFileURL("select", "Select a template.bedrock file");
		if ( strLocation != null && strLocation.indexOf( "template.bedrock" ) != -1 ) {
			return strLocation;
		} else {
			return "";
		}
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
		
		copyFiles( $sourcePath, $targetPath );
		
		var folders = FLfile.listFolder( $sourcePath, "directories" );
		for each ( folderName in folders ) {
			copyFolder( $sourcePath + folderName + "/", $targetPath + folderName + "/" );
		}
	}
	function copyFiles( $sourcePath, $targetPath )
	{
		FLfile.createFolder( $targetPath );
		
		var files = FLfile.listFolder( $sourcePath, "files" );
		for each ( fileName in files ) {
			FLfile.copy( $sourcePath + fileName, $targetPath + fileName );
		}
	}
	function moveFolder( $sourcePath, $targetPath )
	{
		if ( $sourcePath != $targetPath ) {
			copyFolder( $sourcePath, $targetPath );
			FLfile.remove($sourcePath);
		}
	}
	function findFiles( $path, $filename, $results )
	{
		var resultsArr = $results || new Array;
		
		var files = FLfile.listFolder( $path, "files" );
		for each ( var fileName in files ) {
			if ( fileName == $filename ) resultsArr.push( $path + fileName );
		}
		
		var folders = FLfile.listFolder( $path, "directories" );
		for each ( var folderName in folders ) {
			findFiles( $path + folderName + "/", $filename, resultsArr );
		}
		
		return resultsArr;
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
		var arrWords = new String( $text ).split( "_" );
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
				FLfile.remove( $file );
				FLfile.write( $file, strEdited );
			}
		}
	}
	function getNodesAsObject( $data )
	{
		var xmlData = $data;
		var objConversion = new Object;
		
		if ( xmlData.hasComplexContent() ) {
			var numLength = xmlData.children().length();
			for (var i = 0; i  < numLength; i++) {
				objConversion[ xmlData.child( i ).name() ] = sanitize( xmlData.child( i ).toString() );
			}
		}
		return objConversion;
	}
	function getAttributesAsObject( $node )
	{
		var objResult = new Object();
		
		var xmlTemp = new XMLList( $node );
		var xmlAttributes = xmlTemp.attributes();
		
		var numLength = xmlAttributes.length();
		for (var i = 0; i < numLength; i ++) {
			objResult[ xmlAttributes[ i ].name().toString() ] = sanitize( xmlAttributes[ i ].toString() );
		}	
			
		return objResult;
	}