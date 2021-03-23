/**
 * air-ELMS 자바스크립트 도우미 객체
 * @returns {jsHelper_airElms}
 */
function jsHelper_airLms() {}

/**
 * air-ELMS 자바스크립트 도우미 인스턴스
 */
var airLms = new jsHelper_airLms();

/**
 * 관련공문서 선택 팝업
 * @param callbackFunction 선택시 호출할 함수
 * @param denyMunseoUids 조회대상에서 제외할 문서의 키값's
 */
jsHelper_airLms.prototype.popupGwanryeonGongmunseoSelect = function (callbackFunction, denyMunseoUids) 
{
	if (denyMunseoUids == undefined || denyMunseoUids == null) {
		denyMunseoUids = "";
	}
	
	modeCode = "POPUP_MUNSEO_SELECT";
	
	var url = "/ServletController?AIR_ACTION=LMS_TB_MB&AIR_MODE=POPUP_MUNSEO_SELECT";	
	url += "&callbackFunction="+ escape(callbackFunction); //XSS필터링 통과를 위해 escape 적용!
	url += "&denyMunseoUids=" + denyMunseoUids;
	
	airCommon.openWindow(url, '1024', '500', 'popupMunSeoSelect', "yes", "yes");
};

/**
 * 변호사 선택 팝업
 * @param callbackFunction 선택시 호출할 함수
 */
jsHelper_airLms.prototype.popupByeonhosaSelect = function (callbackFunction) 
{
	var url = "/ServletController?AIR_ACTION=SYS_USER&AIR_MODE=POPUP_USER_SELECT";
	url += "&callbackFunction="+ escape(callbackFunction); //XSS필터링 통과를 위해 escape 적용!	
	url += "&companyClsCodes=BS";
	url += "&munseo_bunryu_gbn_cod=LMS";
	
	airCommon.openWindow(url, '1024', '500', 'popupByeonhosaSelect', "yes", "yes");
};

/**
 * 변호사 다중 선택 팝업
 * @param callbackFunction 선택시 호출할 함수
 */
jsHelper_airLms.prototype.popupByeonhosaSelects = function (callbackFunction) 
{
	var url = "/ServletController?AIR_ACTION=SYS_USER&AIR_MODE=POPUP_USER_SELECT";
	url += "&callbackFunction="+ escape(callbackFunction); //XSS필터링 통과를 위해 escape 적용!	
	url += "&companyClsCodes=BS";
	url += "&multipleSelectYn=Y";
	url += "&munseo_bunryu_gbn_cod=LMS";
	
	airCommon.openWindow(url, '1024', '500', 'popupByeonhosaSelects', "yes", "yes");
};


/**
 * 변호사 다중 선택 팝업
 * @param callbackFunction 선택시 호출할 함수
 */
jsHelper_airLms.prototype.popupByeonhosaSelects = function (callbackFunction, multipleSelectYn) 
{
	var url = "/ServletController?AIR_ACTION=SYS_USER&AIR_MODE=POPUP_USER_SELECT";
	url += "&callbackFunction="+ escape(callbackFunction); //XSS필터링 통과를 위해 escape 적용!	
	url += "&companyClsCodes=BS";
	url += "&multipleSelectYn="+multipleSelectYn;
	url += "&munseo_bunryu_gbn_cod=LMS";
	
	airCommon.openWindow(url, '1024', '500', 'popupByeonhosaSelects', "yes", "yes");
};


/**
 * 소송 - 사건검색 팝업
 * @param callbackFunction 선택시 호출할 함수
 */
jsHelper_airLms.prototype.popupSsSimSearch = function (callbackFunction) 
{	
	var url	= "/ServletController?AIR_ACTION=LMS_SS_MAS&AIR_MODE=POPUP_SIM_GLIST";
	url += "&callbackFunction="+ encodeURIComponent(callbackFunction); //XSS필터링 통과를 위해 escape 적용!
	
	airCommon.openWindow(url, '1024', '500', 'popupSsSimSearch', "yes", "yes");
};

/**
 * 관련사건 팝업
 * @param solMasUid
 */
jsHelper_airLms.prototype.goGwanRyeonPopup = function (gbn, solMasUid) 
{	
	var action_code = "LMS_"+gbn+"_LIST_MAS";
	var mode_code = "POPUP_INDEX";
	if("SS" ==  gbn){
		action_code = "LMS_SS_MAS";
		mode_code = "POPUP_INDEX";
		
	}else if("DP" == gbn){
		action_code = "LMS_DEPOSIT";
		mode_code = "POPUP_INDEX";
		
	}else if(gbn.indexOf("OLD") > -1){
		action_code = "LMS_GY_OLD";
	}
	var url	= "/ServletController?AIR_ACTION="+action_code+"&AIR_MODE=POPUP_INDEX";
	url += "&sol_mas_uid="+ solMasUid;
	
	airCommon.openWindow(url, '1024', '800', 'popupGwanRyeonPopup', "yes", "yes");
};

/**
 * 계약 - 팝업
 * @param solMasUid
 * @param gwanriMasUid
 */
jsHelper_airLms.prototype.popupGyTepIndex = function (solMasUid) 
{	
	var url	= "/ServletController?AIR_ACTION=LMS_GY_TEP&AIR_MODE=POPUP_INDEX";
	url += "&sol_mas_uid="+ solMasUid;
	
	airCommon.openWindow(url, '1024', '700', 'popupGyIndex'+solMasUid, "yes", "no");
};

/**
 * 소송 - 소송정보 팝업
 * @param solMasUid
 * @param gwanriMasUid
 */
jsHelper_airLms.prototype.popupSsTepIndex = function (solMasUid) 
{	
	var url	= "/ServletController?AIR_ACTION=LMS_SS_MAS&AIR_MODE=POPUP_INDEX";
	url += "&sol_mas_uid="+ solMasUid;
	
	airCommon.openWindow(url, '1024', '700', 'popupSsTepIndex', "yes", "no");
};

/**
 * 담당자 선택 팝업
 * @param callbackFunction 선택시 호출할 함수
 */
jsHelper_airLms.prototype.popupDamdanjaSelect = function (callbackFunction) 
{
	var url = "/ServletController?AIR_ACTION=SYS_USER&AIR_MODE=POPUP_USER_SELECT";
	url += "&callbackFunction="+ escape(callbackFunction); //XSS필터링 통과를 위해 escape 적용!	
	url += "&userAuthCodes=LMS_BJD";
	url += "&munseo_bunryu_gbn_cod=LMS";
	
	airCommon.openWindow(url, '1024', '500', 'popupDamdanjaSelect', "yes", "yes");
};

/**
 * 소송유형(2차) 콤보 구성용 코드정보 문자열 가져오기
 */
jsHelper_airLms.prototype.getSsMasYuhyeong02ComboCodestr = function (yuhyeong01Cod, defaultCodestr, siteLocale) {
	siteLocale = (siteLocale == undefined || siteLocale == null || siteLocale == "" ? "KO" : siteLocale);
	
	return airCommon.getCodeStrFromXML("SYS_CODE_BY_PARENT_CODE_ID", defaultCodestr, null, yuhyeong01Cod, null, "CODE_ID,NAME_"+ siteLocale);
};

/**
 * 변호사 콤보 구성용 코드정보 문자열 가져오기
 */
jsHelper_airLms.prototype.getSsMasByeonhosaComboCodestr = function (yuhyeong01Cod, defaultCodestr, siteLocale) {
	siteLocale = (siteLocale == undefined || siteLocale == null || siteLocale == "" ? "KO" : siteLocale);
	
	return airCommon.getCodeStrFromXML("SYS_USER_BY_GROUP_CODE", defaultCodestr, "", yuhyeong01Cod, "USER_ID,NAME_"+ siteLocale);
};

/**
 * 소송 심급차수 관련 기일정보 코드정보 문자열 가져오기 
 * @param ssMasUid
 * @param simChaNo
 * @returns {String}
 */
jsHelper_airLms.prototype.getSsGiilCodestrBySimChaNo = function (defaultCodestr, ssMasUid, simChaNo) {
	var res = defaultCodestr;
	
	var url = "/ServletController";
	var qstr = "AIR_ACTION=LMS_SS_GIIL&AIR_MODE=XML_CODESTR_BY_SIM_CHA_NO";
	qstr += "&ss_mas_uid="+ ssMasUid;
	qstr += "&sim_cha_no="+ simChaNo;
	
	var xmlHttp = airCommon.getXmlHttpRequestFromUrl(url, qstr);
	if (xmlHttp != null) {
		var data = xmlHttp.responseXML.getElementsByTagName("DATA").item(0).firstChild.nodeValue;
		
		if (data != "") {
			res += (res != null && res != "" ? "^" : "") + data;
		}
	}
	
	return res;
};

/**
 * 소송 심급차수 관련 소송위임 대리인 정보 JSON 데이터 가져오기 
 * @param ssMasUid
 * @param simChaNo
 * @returns {String}
 */
jsHelper_airLms.prototype.getSsWiimInJsonBySimChaNo = function (ssMasUid, simChaNo) {
	var res = null;
	
	var url = "/ServletController";
	var qstr = "AIR_ACTION=LMS_SS_WIIM&AIR_MODE=JSON_WIIM_IN_LIST_BY_SIM_CHA_NO";
	qstr += "&ss_mas_uid="+ ssMasUid;
	qstr += "&sim_cha_no="+ simChaNo;
	
	var xmlHttp = airCommon.getXmlHttpRequestFromUrl(url, qstr);
	if (xmlHttp != null) {
		res = airCommon.parseJson(xmlHttp.responseText);		
	}
	
	return res;
};

/**
 * 소송 심급차수 관련 비용 지급대상 코드정보 문자열 가져오기 
 * @param ssMasUid
 * @param simChaNo
 * @returns {String}
 */
jsHelper_airLms.prototype.getSsBiyongJigeubDaesangCodestr = function (defaultCodestr, ssMasUid, simChaNo) {
	var res = defaultCodestr;
	
	var url = "/ServletController";
	var qstr = "AIR_ACTION=LMS_SS_BIYONG&AIR_MODE=XML_JIGEUB_DAESANG_CODESTR";
	qstr += "&ss_mas_uid="+ ssMasUid;
	qstr += "&sim_cha_no="+ simChaNo;
	
	var xmlHttp = airCommon.getXmlHttpRequestFromUrl(url, qstr);
	if (xmlHttp != null) {
		var data = xmlHttp.responseXML.getElementsByTagName("DATA").item(0).firstChild.nodeValue;
		
		if (data != "") {
			res += (res != null && res != "" ? "^" : "") + data;
		}
	}
	
	return res;
};

/**
 * TEP 팝업창 오픈
 * @param docMasUid
 * @param solMasUid
 * @param docFlowUid
 */
jsHelper_airLms.prototype.popupTepIndex = function (docMasUid, solMasUid, docFlowUid) {
	if (solMasUid == undefined) solMasUid = "";
	if (docFlowUid == undefined) docFlowUid = "";
	
	var url = "/ServletController"
			+ "?AIR_ACTION=LMS_MAIN"
			+ "&AIR_MODE=POPUP_INDEX"
			+ "&doc_mas_uid="+ docMasUid
			+ "&sol_mas_uid="+ solMasUid
			+ "&doc_flow_uid="+ docFlowUid;			
	
	airCommon.openWindow(url, "1024", "650", "TEP_"+ (solMasUid != "" ? solMasUid : docMasUid), "yes", "yes");
};

/**
 * TEP 팝업창 오픈
 * @param docMasUid
 * @param solMasUid
 * @param docFlowUid
 * @param callbackFunction 선택시 호출할 함수
 */
jsHelper_airLms.prototype.popupTepIndex = function (docMasUid, solMasUid, docFlowUid, callbackFunction) {
	if (solMasUid == undefined) solMasUid = "";
	if (docFlowUid == undefined) docFlowUid = "";
	
	var url = "/ServletController"
			+ "?AIR_ACTION=LMS_MAIN"
			+ "&AIR_MODE=POPUP_INDEX"
			+ "&doc_mas_uid="+ docMasUid
			+ "&sol_mas_uid="+ solMasUid
			+ "&doc_flow_uid="+ docFlowUid
			;			

	url += "&callbackFunction="+ escape(callbackFunction); //XSS필터링 통과를 위해 escape 적용!
	
	airCommon.openWindow(url, "1024", "650", "TEP_"+ (solMasUid != "" ? solMasUid : docMasUid), "yes", "yes");
};

/**
 * 사외변호사 정보 바로가기
 */
jsHelper_airLms.prototype.popupByeonhosa = function (lms_pati_byeonhosa_id) {
	/* var byeonhosa_nam = decodeURI(decodeURIComponent(lms_pati_byeonhosa_nam)); */
	airCommon.openWindow('/ServletController?AIR_ACTION=LMS_BYEONHOSA&AIR_MODE=POPUP_GLIST&schValue='+ lms_pati_byeonhosa_id +'&schCsf=LOGIN_ID', 1024, 660, '사외변호사정보', 'yes', 'yes');
};

/**
 * 사용자 메뉴얼 다운로드 팝업 오픈
 * 
 * SYS_COM_GROUP_001	코스맥스비티아이㈜
 * SYS_COM_GROUP_002	쓰리애플즈코스메틱스㈜
 * SYS_COM_GROUP_003	코스맥스바이오㈜
 * SYS_COM_GROUP_004	㈜생명의나무에프앤비
 * SYS_COM_GROUP_005	코스맥스바이오텍
 * SYS_COM_GROUP_006	코스맥스엔비티㈜
 * SYS_COM_GROUP_007	코스맥스엔에스㈜
 * SYS_COM_GROUP_008	㈜닥터디앤에이
 * SYS_COM_GROUP_009	코스맥스엔비티(상해)생물과기유한공사
 * SYS_COM_GROUP_010	COSMAXNBT USA, INC
 * SYS_COM_GROUP_011	COSMAXNBT AUS PTY.LTD.
 * SYS_COM_GROUP_012	COSMAXNBT SG PTE.LTD.
 * SYS_COM_GROUP_013	코스맥스파마㈜
 * SYS_COM_GROUP_014	투윈파마(주)
 * SYS_COM_GROUP_015	코스맥스 상해
 * SYS_COM_GROUP_016	코스맥스㈜
 * SYS_COM_GROUP_017	코스맥스 중국
 * SYS_COM_GROUP_018	코스맥스 광저우
 * SYS_COM_GROUP_019	코스맥스 인도네시아
 * SYS_COM_GROUP_020	코스맥스 웨스트
 * SYS_COM_GROUP_021	코스맥스 미국
 * SYS_COM_GROUP_022	뉴월드
 * SYS_COM_GROUP_023	코스맥스태국
 * SYS_COM_GROUP_024	코스맥스아이큐어㈜
 * SYS_COM_GROUP_025	농업회사법인코스맥스향약원㈜
 * SYS_COM_GROUP_026	코스맥스닷랩㈜
 * SYS_COM_GROUP_027	씨엠테크㈜
 * SYS_COM_GROUP_028	씨엠테크 중국
 * SYS_COM_GROUP_029	레시피
 */
jsHelper_airLms.prototype.popupUserManualDownload = function (hoesa_cod) {
	
	if(hoesa_cod == "SYS_COM_GROUP_006"){
		airCommon.popupFormDownload("manual", "UserManual_NBT.pdf");
	}else if(hoesa_cod == "SYS_COM_GROUP_007"){
		airCommon.popupFormDownload("manual", "UserManual_NBT.pdf");
	}else if(hoesa_cod == "SYS_COM_GROUP_008"){
		airCommon.popupFormDownload("manual", "UserManual_NBT.pdf");
	}else if(hoesa_cod == "SYS_COM_GROUP_009"){
		airCommon.popupFormDownload("manual", "UserManual_NBT.pdf");
	}else if(hoesa_cod == "SYS_COM_GROUP_010"){
		airCommon.popupFormDownload("manual", "UserManual_NBT.pdf");
	}else if(hoesa_cod == "SYS_COM_GROUP_011"){
		airCommon.popupFormDownload("manual", "UserManual_NBT.pdf");
	}else if(hoesa_cod == "SYS_COM_GROUP_012"){
		airCommon.popupFormDownload("manual", "UserManual_NBT.pdf");
	}else{
		airCommon.popupFormDownload("manual", "UserManual.pdf");
	}
};

/**
 * 운영자 메뉴얼 다운로드 팝업 오픈
 */
jsHelper_airLms.prototype.popupLegalTeamManualDownload = function (hoesa_cod) {
	
	if(hoesa_cod == "SYS_COM_GROUP_006"){
		airCommon.popupFormDownload("manual", "LegalTeamManual.pdf");
	}else if(hoesa_cod == "SYS_COM_GROUP_007"){
		airCommon.popupFormDownload("manual", "LegalTeamManual.pdf");
	}else if(hoesa_cod == "SYS_COM_GROUP_008"){
		airCommon.popupFormDownload("manual", "LegalTeamManual.pdf");
	}else{
		airCommon.popupFormDownload("manual", "LegalTeamManual.pdf");
	}
	
	
};

jsHelper_airLms.prototype.popupReviewDownload = function () {
	airCommon.popupFormDownload("manual", "SAEOBBUSEO_GEOMTOAN_YANGSING.xlsx");
};

/**
 * 관련 계약/자문/소송/분쟁 선택 팝업
 * @param document.form
 */
jsHelper_airLms.prototype.popupRelSelect = function (sol_mas_uid, gubun, callbackFunction, add_save,TEP_CODE,frameId) {

	var url = '/ServletController';
	url += '?AIR_ACTION=LMS_REL_MAS';
	url += '&AIR_MODE=POPUP_REL_SELECT';
	url += '&sol_mas_uid='+sol_mas_uid;
	url += '&gubun='+gubun;
	url += '&add_save='+add_save;
	url += '&TEP_CODE='+TEP_CODE;
	url += '&frameId='+frameId;
	url += '&callbackFunction='+escape(callbackFunction);

	
    
    airCommon.openWindow(url, 1024, 700, 'popGyList', 'yes', 'yes' );
};

/**
 * 2016.09.29 SSJ 단일 선택용 매서드 제작.
 * 관련 계약/자문/소송/분쟁 선택 팝업
 * @param document.form
 */
jsHelper_airLms.prototype.popupRelSelect_noMulti = function (sol_mas_uid, callbackFunction) {
	
	var url = '/ServletController';
	url += '?AIR_ACTION=LMS_REL_MAS';
	url += '&AIR_MODE=POPUP_REL_SELECT_NO';
	url += '&sol_mas_uid='+sol_mas_uid;
	url += '&callbackFunction='+escape(callbackFunction);
	url += '&multiYn=N';
    
    airCommon.openWindow(url, 1024, 650, 'popGyList', 'yes', 'yes' );
};

/**
 * 관련 계약/자문/소송/분쟁 선택 팝업(기존선택된 sol_mas_id 가져감)
 * @param document.form
 */
jsHelper_airLms.prototype.popupRelSelectWithSelected= function ( gwanryeon_gy_uids,sol_mas_uid, callbackFunction) {
	var url = '/ServletController';
	url += '?AIR_ACTION=LMS_REL_MAS';
	url += '&AIR_MODE=POPUP_REL_SELECT';
	url += '&sol_mas_uid='+sol_mas_uid; 
	url += '&gwanryeon_gy_uids='+ gwanryeon_gy_uids;
	url += '&callbackFunction='+escape(callbackFunction);
    
    airCommon.openWindow(url, 1024, 650, 'popGyList', 'yes', 'yes' );
};

/**
 * 관련 계약/자문/소송/분쟁 선택 팝업 (구분값에 의해 자문/소송/계약 각각 불러옴)
 * @param document.form
 */
jsHelper_airLms.prototype.popupRelSelectByGubun = function (gubun, gwanryeon_gy_uids, sol_mas_uid, callbackFunction) {
	var url = '/ServletController';
	url += '?AIR_ACTION=LMS_REL_MAS';
	url += '&AIR_MODE=POPUP_REL_SELECT';
	url += '&sol_mas_uid='+sol_mas_uid;
	url += '&gubun='+gubun;
	url += '&gwanryeon_gy_uids='+ gwanryeon_gy_uids;
	url += '&callbackFunction='+escape(callbackFunction);
    
    airCommon.openWindow(url, 1024, 650, 'popGyList', 'yes', 'yes' );
};


/**
 * 외부변호사위임 변호사 선택 팝업
 * @param callbackFunction 선택시 호출할 함수
 * @param sol_mas_uid SOL_MAS_UID
 * @param multipleSelectYn 다중선택or단일선택 [Y, N], Default Y
 */
jsHelper_airLms.prototype.popupWiimSusinjaSelects = function (callbackFunction, sol_mas_uid, multipleSelectYn) 
{
	multipleSelectYn = (multipleSelectYn == undefined || multipleSelectYn == null ? "Y" : multipleSelectYn);
	
	var url = "/ServletController?AIR_ACTION=LMS_GT_EXT_EMPLOY&AIR_MODE=POPUP_SUSINJA_SELECT";
	url += "&callbackFunction="+ escape(callbackFunction); //XSS필터링 통과를 위해 escape 적용!
	url += "&multipleSelectYn="+ multipleSelectYn;
	url += "&sol_mas_uid="+ sol_mas_uid;
	
	airCommon.openWindow(url, '1024', '500', 'popupWiimSusinjaSelects', "yes", "yes");
};


/**
 * selectbox 선택시 텍스트 정보 셋팅
 * @param callbackFunction 선택시 호출할 함수
 * @param sol_mas_uid SOL_MAS_UID
 * @param multipleSelectYn 다중선택or단일선택 [Y, N], Default Y
 */
jsHelper_airLms.prototype.setOptText = function (formObj,  toObj) 
{
	
	$('#HOESA_NAM').val($('#HOESA_COD option:selected').text());
	
	$(toObj).val($(formObj).find("option:selected").text());
};
