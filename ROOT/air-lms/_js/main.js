/**
 * Main 자바스크립트 도우미 객체
 * @returns {jsHelper_main}
 * @author sitas
 */
function jsHelper_main() {}

/**
 * Main 자바스크립트 도우미 인스턴스
 */
var main = new jsHelper_main();


/**
 * 로컬 저장소 사용
 */
jsHelper_main.prototype.setLocalStorage = function(key, val) {	
	localStorage.setItem(key,val);
	main.setLineStyle();
}
/**
 * 읽은 문서 컬러 해제
 */
jsHelper_main.prototype.setLineStyle = function() {	
	var lsCnt = localStorage.length;
	for (var i = 0; i < lsCnt; i++){
	    var key = localStorage.getItem(localStorage.key(i));
		$("#"+key).removeAttr("class");
	}
}

/**
 * 목록페이지 이동
 */
jsHelper_main.prototype.goPage = function(actionCode, modeCode, etcQStr) {	
	
	var url = "/ServletController";
	url += "?AIR_ACTION="+ actionCode;
	url += "&AIR_MODE="+ modeCode;
	
	if (etcQStr != undefined) url += etcQStr;
	location.href = url;
}

/**
 * 문서 열람(공통)
 * @param actionCode
 * @param modeCode
 * @param etcQStr
 */
jsHelper_main.prototype.goPopupIndex = function (gbn, sol_mas_uid, gb_doc_mas_uid, apr_no) {	
	
	var url = "";
	if("SS" == gbn){
		url = "/ServletController?AIR_ACTION=LMS_SS_MAS&AIR_MODE=POPUP_INDEX&sol_mas_uid="+ sol_mas_uid+"&gb_doc_mas_uid="+ gb_doc_mas_uid;
	
	}else if("GY" == gbn){
		url = "/ServletController?AIR_ACTION=LMS_GY_LIST_MAS&AIR_MODE=POPUP_INDEX&sol_mas_uid="+ sol_mas_uid;

	}else if("JM" == gbn){
		url = "/ServletController?AIR_ACTION=LMS_JM_LIST_MAS&AIR_MODE=POPUP_INDEX&sol_mas_uid="+ sol_mas_uid;
		
	}else if("IJ" == gbn){
		url = "/ServletController?AIR_ACTION=LMS_IJ_LIST_MAS&AIR_MODE=POPUP_INDEX&sol_mas_uid="+ sol_mas_uid;
		
	}else if("APR" == gbn){
		url = "/ServletController?AIR_ACTION=SYS_APR_TEP&AIR_MODE=INDEX&sol_mas_uid="+ sol_mas_uid+"&apr_no="+ apr_no+"&view_doc_mas_uid="+ gb_doc_mas_uid;
		
	}
	
	if( "" != url){
		airCommon.openWindow(url, "1024", "800", "POPUP_TEP_VIEW_"+sol_mas_uid, "yes", "yes", "");
	}
}

/**
 * 문서 열람(공통)
 * @param actionCode
 * @param modeCode
 * @param etcQStr
 */
jsHelper_main.prototype.goPopup = function (actionCode, modeCode, etcQStr) {	
	
	var url = "/ServletController";
	url += "?AIR_ACTION="+ actionCode;
	url += "&AIR_MODE="+ modeCode;
	
	if (etcQStr != undefined) url += etcQStr;
	airCommon.openWindow(url, "1024", "800", "POPUP_VIEW_FORM", "yes", "yes", "");
}

/**
 * 결재문서함 팝업
 * @param actionCode
 * @param modeCode
 * @param etcQStr
 */
jsHelper_main.prototype.MainGyeol_View = function () {	
    airCommon.openWindow('/ServletController?AIR_ACTION=SYS_APR&AIR_MODE=POPUP_APR_LIST', 1024, 490, '결재문서', 'yes', 'yes');
}

/**
 * 상태 건리스트 팝업
 */
jsHelper_main.prototype.goPopUpStat = function (actionCode, modeCode, etcQStr){
	
	var url = "/ServletController?AIR_ACTION="+ actionCode +"&AIR_MODE="+ modeCode;
  	if (etcQStr != undefined) url += etcQStr;  

    airCommon.openWindow(url, 1024, 400, 'POPUP_LIST', 'yes', 'no');
}

/**
 * 일정 상세 팝업
 */
jsHelper_main.prototype.openViewSchedule = function (scdlUid){

	var url = "/ServletController?AIR_ACTION=CMM_SCDL&AIR_MODE=POPUP_VIEW";
	url += "&scdl_uid="+ scdlUid;
	
	airCommon.openWindow(url, "1024", "520", "popupScheduleList", "yes", "yes");	
}

/**
 * 각종 BBS 팝업(공지사항, 주간보고 등...)
 */
jsHelper_main.prototype.openBbsView = function (actionCode, modeCode, etcQStr){
	
	var url = "/ServletController";
	url += "?AIR_ACTION="+ actionCode;
	url += "&AIR_MODE="+ modeCode;
	
	if (etcQStr != undefined) url += etcQStr;
	airCommon.openWindow(url, "1024", "550", "POPUP_VIEW_FORM", "yes", "yes", "");
}
/*
*//**
 * 담당자 진행 카운트 Data load
 *//*
jsHelper_main.prototype.loadStatusChr = function (callback){
	
	$.ajax({
		url: "/ServletController"
		, type: "POST"
		, async: true
		, cache: false
		, data: {
			AIR_ACTION:"LMS_MAIN"
			,AIR_MODE:"CHR_STATUS_LIST"
		}
		, dataType: "json"
	}).done(function(data){
		callback(data);
		
	}).fail(function(){
	});
}

*//**
 * 일반사용자 진행 카운트 Data load
 *//*
jsHelper_main.prototype.loadStatusUsr = function (callback){
	
	$.ajax({
		url: "/ServletController"
			, type: "POST"
			, async: true
			, cache: false
			, data: {
				AIR_ACTION:"LMS_MAIN"
				,AIR_MODE:"USR_STATUS_LIST"
			}
			, dataType: "json"
	}).done(function(data){
		callback(data);
		
	}).fail(function(){
	});
}

*//**
 * 계약/자문 DIV load()
 * @param mode (GYEYAG/JAMUN)
 *//*
jsHelper_main.prototype.loadGyJm = function(mode){
	if("GYEYAG" == mode){
		$("#GY_HEAD").css("font-weight","bold");
		$("#JM_HEAD").css("font-weight","normal");
		$("#SS_HEAD").css("font-weight","normal");
		$("#list_type").val("GY");
		var url="/ServletController?AIR_ACTION=LMS_MAIN&AIR_MODE="+mode+"&board_rowsize=9";
	}else if("JAMUN" == mode){
		$("#GY_HEAD").css("font-weight","normal");
		$("#JM_HEAD").css("font-weight","bold");
		$("#SS_HEAD").css("font-weight","normal");
		$("#list_type").val("JM");
		var url="/ServletController?AIR_ACTION=LMS_MAIN&AIR_MODE="+mode+"&board_rowsize=9";
	}else { //SOSONG
		$("#GY_HEAD").css("font-weight","normal");
		$("#JM_HEAD").css("font-weight","normal");
		$("#SS_HEAD").css("font-weight","bold");
		$("#list_type").val("SS");
		var url="/ServletController?AIR_ACTION=LMS_MAIN&AIR_MODE=SOSONG&menu_div=SS&board_action_code=LMS_SS_TEP&board_rowsize=9";
	}
	 
	$("#areaGyJm").load(url,function(){
		main.setLineStyle();
	});
}


*//**
 * 나의 의뢰건 DIV load
 *//*
jsHelper_main.prototype.loadMyReq = function(mode){
	var url="/ServletController?AIR_ACTION=LMS_MAIN&AIR_MODE=MY_REQ&board_rowsize=10";
	 
	$("#areaMyReq").load(url,function(){
		main.setLineStyle();
	});
}
*/
/**
 * 공지사항 로드
 */
jsHelper_main.prototype.loadNotice = function(){
	var url="/ServletController?AIR_ACTION=LMS_MAIN&AIR_MODE=BBS_NOTICE&board_action_code=LMS_BBS&board_cd=BOARD_NOTICE&board_type=LMS_BBS_BOARD&board_rowsize=6";
	
	$("#areaNoticeUsr").load(url,function(){
		main.setLineStyle();
	});	
}


/**
 * 일정로드
 */
jsHelper_main.prototype.loadScdl = function(){
	$(".panel04").load("/ServletController?AIR_ACTION=CMM_SCDL&AIR_MODE=SELECT&showTodayListYn=Y");
}

/**
 * 1주간 일정 로드
 */
jsHelper_main.prototype.loadScdlList = function(){
	$("#areaScdlList").load("/ServletController?AIR_ACTION=CMM_SCDL&AIR_MODE=AFTER_SCDL&showTodayListYn=Y&rangeDay=7",function(){
		main.setLineStyle();
	});	
}

/**
 * 주간보고 로드
 */
jsHelper_main.prototype.loadWeek = function(){
	var url="/ServletController?AIR_ACTION=LMS_MAIN&AIR_MODE=BBS_WEEK&board_action_code=LMS_BBS&board_cd=BOARD_JUGANBOGO&board_type=LMS_BBS_BOARD&TYPE_CD1=BOARD_JUGANBOGO_01&board_rowsize=5";
	$("#areaWeek").load(url,function(){
		main.setLineStyle();
	});
}

/**
 * 최근 게시판 로드
 */
jsHelper_main.prototype.loadBoard = function(){
	var url="/ServletController?AIR_ACTION=LMS_MAIN&AIR_MODE=BBS_BOARD&board_action_code=LMS_BBS&board_cd=BOARD_NOTICE_QA_FILE&board_type=LMS_BBS_BOARD&board_rowsize=3";
	$("#areaBoard").load(url,function(){
		main.setLineStyle();
	});	
}


/**
 * 해당 리스트 이동
 * @param type GY/JM/SS/GY_JM
 * @param addParam
 */
jsHelper_main.prototype.goDetail = function(type, addParam){
	
	var url = "";
	if("GY_JM" == type){
		var list_type = $("#list_type").val();
		
		if("GY" == list_type){
			url = "/ServletController?AIR_ACTION=LMS_GY_LIST_MAS&AIR_MODE=GLIST&schGubun=My";
		}else if("JM" == list_type){
			url = "/ServletController?AIR_ACTION=LMS_JM_LIST_MAS&AIR_MODE=GLIST&schGubun=My";
		}else if("SS" == list_type){
			url = "/ServletController?AIR_ACTION=LMS_SS_MAS&AIR_MODE=GLIST&schGubun=My";
		}
		location.href = url;
		
	}else if("GY" == type){
		url = "/ServletController?AIR_ACTION=LMS_GY_LIST_MAS&AIR_MODE=GLIST&schGubun=My"+addParam;
 		location.href = url;
 	
	}else if("JM" == type){
		url = "/ServletController?AIR_ACTION=LMS_JM_LIST_MAS&AIR_MODE=GLIST&schGubun=My"+addParam;
 		location.href = url;
 		
	}else if("IJ" == type){
		url = "/ServletController?AIR_ACTION=LMS_IJ_LIST_MAS&AIR_MODE=GLIST&schGubun=My";
		location.href = url;
		
	}else if("NOTI" == type){
 		url = "/ServletController?AIR_ACTION=LMS_BBS&AIR_MODE=GLIST&BOARD_CD=BOARD_NOTICE";
 		location.href = url;
 	
	}else if("BOARD" == type){
 		url = "/ServletController?AIR_ACTION=LMS_BBS&AIR_MODE=GLIST&BOARD_CD=BOARD_NOTICE";
 		location.href = url;
 		
	}else if("WEEK" == type){
		url = "/ServletController?AIR_ACTION=LMS_BBS&AIR_MODE=JUGANBOGO_GLIST&BOARD_CD=BOARD_JUGANBOGO&TYPE_CD1=BOARD_JUGANBOGO_01";
		
		location.href = url;
	}else if("SCDL" == type){
		url = "/ServletController?AIR_ACTION=CMM_SCDL&AIR_MODE=LIST"+addParam;
		
		airCommon.openWindow(url, "1024", "500", "popupScheduleList", "yes", "yes");	
	}else if("SS" == type){
		//url = "/ServletController?AIR_ACTION=LMS_SS_MAS&AIR_MODE=GLIST&schGubun=My";
		//location.href = url;
	}else if("PJ" == type){
		url = "/ServletController?AIR_ACTION=LMS_PJ_MAS&AIR_MODE=GLIST";
		location.href = url;
	}else if("STD_GY" == type){
		url = "/ServletController?AIR_ACTION=LMS_STD_GY&AIR_MODE=GLIST";
		location.href = url;
	}
}

/**
 * 결재할 건이 있을시 결재창 팝업
 */
jsHelper_main.prototype.initGyeolPop = function(callback){
	$.ajax({
		url: "/ServletController"
			, type: "POST"
			, async: true
			, cache: false
			, data: {
				AIR_ACTION:"LMS_MAIN"
				,AIR_MODE:"JSON_GYEOL_LIST"
				,apr_stu:"W"
			}
			, dataType: "json"
	}).done(function(data){
		callback(data);
	}).fail(function(){
	});
	
}

/**
 * 메인화면 css 처리(법무팀용)
 */
$(document).ready(function() {
	$('.total_area').on('mouseover', 'li.box', function() {
		$(this).siblings().removeClass('active');
	}).on('mouseout', function() {
		$(this).find('.box:first').addClass('active');
	});
});

/**
 * 메인화면 css 처리(현업용)
 */
$(document).ready(function() {
	$('.total_area_usr').on('mouseover', 'li.box', function() {
		$(this).siblings().removeClass('active');
	}).on('mouseout', function() {
		$(this).find('.box:first').addClass('active');
	});
});