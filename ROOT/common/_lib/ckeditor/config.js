/**
 * @license Copyright (c) 2003-2015, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {

	config.uiColor = '#FAFAFA';
	config.enterMode = CKEDITOR.ENTER_DIV;
	config.toolbar =[
	                   ['Bold','Italic','Underline','Strike', 'Subscript','Superscript'],
	                   ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
	                   ['NumberedList','BulletedList','Outdent','Indent','Blockquote'],
	                   ['HorizontalRule','Smiley','SpecialChar'],
	                   ['Styles','Format','Font','FontSize','TextColor','BGColor','Maximize']
	                   ];
	 					/*['Table','Image','CreateDiv','Source','Preview','-','Cut','Copy','Paste','PasteText','PasteFromWord','Undo','Redo','SelectAll','RemoveFormat']*/
	
	config.font_names = '맑은 고딕; 굴림; 돋움; 궁서; HY견고딕; HY견명조; 휴먼둥근헤드라인;' 
	      + '휴먼매직체; 휴먼모음T; 휴먼아미체; 휴먼엑스포; 휴먼옛체; 휴먼편지체;' 
	      +  CKEDITOR.config.font_names;
	config.removePlugins = 'magicline,elementspath';
	//config.forcePasteAsPlainText = true;
	
	config.pasteFromWordRemoveFontStyles = false;
	config.pasteFromWordRemoveStyles = false;
	config.allowedContent = true;
	

};
