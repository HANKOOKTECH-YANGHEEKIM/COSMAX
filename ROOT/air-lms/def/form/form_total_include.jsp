<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.lms.def.util.StuUtil"%>
<%@ page import="com.emfrontier.air.common.bean.*"%>
<%@ page import="com.emfrontier.air.common.config.*"%>
<%@ page import="com.emfrontier.air.common.jdbc.*"%>
<%@ page import="com.emfrontier.air.common.model.*"%>
<%@ page import="com.emfrontier.air.common.util.*"%>
<%@page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%--
* 새로운 문서 뷰 JSP
* 해당 jsp에서는 새로운 문서처리 방식을 사용한다.
  솔루션에 물려 저장된 문서를 뷰 또는 작성 모드로 표현하고 표시 하고 설정된 상태에 따라 프로세스를 처리 한다.
  ---문서뷰영역   : 문서가 작성되고 해당 상태를 떠났을때는 뷰 모드로 표시 한다.
  ---문서작성영역 : 최종 진행 문서가 임시저장이거나 다음진행문서가 존재 할 경우 작성 모드로 표시한다.(권한체크 함)
  ---TODO영역   : 최종 또는 다음진행문서 , 상태, 권한에 따른 설정된(상태정의OUT) 다음대상 상태가 존재할 경우 버튼으로 표시 한다.
--%>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser = (SysLoginModel) request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale = loginUser.getSiteLocale();

	//-- 요청값 셋팅
	BeanResultMap requestMap = (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);
	String sol_mas_uid		= requestMap.getString("SOL_MAS_UID");
	String systemId		= requestMap.getString("SYSTEM_ID");
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	SQLResults DATA_LIST = resultMap.getResult("DATA_LIST");
	
	SQLResults LMS_MAS = resultMap.getResult("LMS_MAS");
	BeanResultMap lmsMap = new BeanResultMap();  
	if(LMS_MAS != null && LMS_MAS.getRowCount() > 0){
		lmsMap.putAll(LMS_MAS.getRowResult(0));
	}
	String stu_id = lmsMap.getString("STU_ID");
	//-- 현재 상태값 명칭
	String stuNm = lmsMap.getString("STU_NAM");
	
// 	if("")
// 		BOAN_DUNGGUB = 'LMS_BOAN_IB_SHARE'
	

	boolean isAuths = true;
	if("LMS_BOAN_IB_SHARE".equals(lmsMap.getString("BOAN_DUNGGUB"))) isAuths = false; //-- 보안등급 일반(공유) 일경우 체크 시작
	
	if(!isAuths && 
			LmsUtil.isBeobmuOfiUser(loginUser)||
			loginUser.getLoginId().equals(lmsMap.getString("YOCHEONG_ID")) ||
			lmsMap.getString("CHAMJOJA_COD").indexOf(loginUser.getLoginId()) > - 1 ||
			LmsUtil.isSysAdminUser(loginUser)
	){// 법무팀 무조건, 요청자, 요청부서
		isAuths = true;
	}

%>
<div id="formViewPanels<%=sol_mas_uid%>">
<%-- <div id="formViewPanels<%=sol_mas_uid%>" class="easyui-accordion" data-options="multiple:true" style="width:auto;height:auto;"> --%>
<%
boolean isNextForm = false;
boolean isLastView = false;
String last_form_no = "";
String next_form_no = "";
String next_stu_id = "";
String next_form_nm = "";
String data_doc_uid = "";
String last_doc_stu = "";
String last_doc_uid = "";
String last_group_uid = "";
if(DATA_LIST != null && DATA_LIST.getRowCount() > 0){
	for(int i=0; i < DATA_LIST.getRowCount(); i++){
// 		System.out.println(DATA_LIST.getRowResult(i));
		String doc_johoe_auth_codes 	= DATA_LIST.getString(i, "DOC_JOHOE_AUTH_CODES");
		String iparam_doc_mas_uid 		= DATA_LIST.getString(i, "DOC_MAS_UID");
		String munseo_seosig_no 		= DATA_LIST.getString(i, "MUNSEO_SEOSIG_NO");
		String group_uid		 		= DATA_LIST.getString(i, "GROUP_UID");
		String doc_stu		 			= DATA_LIST.getString(i, "DOC_STU");
		String apr_ids		 			= DATA_LIST.getString(i, "APR_IDS");
		String langCode					= DATA_LIST.getString(i, "LANG_CODE");
		String iparam_munseo_seosig_nam = StringUtil.getLang(langCode, siteLocale);
		String panelId 					= "accordion-"+iparam_doc_mas_uid;
		String onLoadFn					=	""; //-- 로드 후 하단으로 내리기
		//문서 조회 권한
		boolean isShare = true;
		boolean isJohoeAuthYn = false;
		if(loginUser.isUserAuth(doc_johoe_auth_codes)){
			isJohoeAuthYn = true;
		}
		if(!isJohoeAuthYn){
			iparam_munseo_seosig_nam += " - "+StringUtil.getLocaleWord("L.열람권한없음", siteLocale);
		}
		
		
		//-- true:닫힘 , false : 열림
		String collapsibleYn = "";

		// 문서 조회 권한별 열림 설정
	    if(isJohoeAuthYn){
	    	collapsibleYn = "true";
	    	
	        // 마지막 문서만 열린 상태로 설정
	    	if(i < DATA_LIST.getRowCount() - 1) {
	        	collapsibleYn = "true";
	        } else {
	        	collapsibleYn = "false";
	        }
	    	
	    }else{
	    	collapsibleYn = "true";
	    }
		boolean isTodo = false;	//-- 작성 투두 체크
		if(StringUtil.isNotBlank(StuUtil.getLmsAuth( lmsMap, loginUser)) 
				&&  StuUtil.getAuthCompare(DATA_LIST.getString(i, "AUTH_CD"), StuUtil.getLmsAuth( lmsMap, loginUser))
				) isTodo = true;
		
		
	    String href = "/ServletController?AIR_ACTION=SYS_FORM";
	    if(i == (DATA_LIST.getRowCount()-1) 
	    		&& isTodo
	    ){	//--마지막 문서일때 프로세스 구분이 SAVE이면 수정 모드로 열림(해당 TODO자에게만 적용)
	    	
	    	next_stu_id		 			= DATA_LIST.getString(i, "NEXT_STU_ID");
	    	next_form_no		 		= DATA_LIST.getString(i, "NEXT_FORM_NO");
	    	next_form_nm		 		= DATA_LIST.getString(i, "NEXT_FORM_NAM_"+siteLocale);
	    	last_form_no				= munseo_seosig_no;
	    	last_doc_stu				= doc_stu;
	    	//-- 마지막 문서와 다음문서가 같을경우 작성 상태로 열림
			if(munseo_seosig_no.equals(next_form_no) && "T".equals(doc_stu)
					){
				href += "&AIR_MODE=WRITE_FORM_INCLUDE";
    			panelId = "accordion-WRITE";
		    	onLoadFn = ",onLoad:function(){setLoadPanel"+sol_mas_uid+"();}";
		    	isLastView = true;					//-- 최종 문서가 작성 문서와 같은경우에는 뷰모드를 뿌리지 않는다.
		    	isNextForm = true;					
		    	data_doc_uid				= iparam_doc_mas_uid;
		    	last_doc_uid				= iparam_doc_mas_uid;
		    	last_group_uid				= group_uid;
			}else if(munseo_seosig_no.equals(next_form_no) && "R".equals(doc_stu)){
				
				href += "&AIR_MODE=VIEW_FORM_ONE";
				isNextForm 		= true;
		    	last_group_uid				= group_uid;
		    	data_doc_uid				= iparam_doc_mas_uid;
				
	    	}else{
	    		//-- 다음 진행문서 여부 타진~!!
	    		if(StringUtil.isNotBlank(next_form_no) && !munseo_seosig_no.equals(next_form_no)){		
	    			isNextForm 		= true;					//-- 현재문서는 뷰로 다음진행문서는 작성상태로 지정
	    			last_group_uid 	= "";					//-- 다른 문서로 작성 대상일때는 그룹UID를 계승하지 않는다.(리비전 문서가 아니기 때문)
	    		}
	    		
				href += "&AIR_MODE=VIEW_FORM_ONE";
	    	}
	    }else{
			href += "&AIR_MODE=VIEW_FORM_ONE";
	    }
		href += "&group_uid="+group_uid;
		href += "&sol_mas_uid="+sol_mas_uid;
		href += "&doc_mas_uid="+iparam_doc_mas_uid;
		href += "&munseo_seosig_no="+munseo_seosig_no;
		if(!isAuths && ("DDD-LMS-GY-018".equals(munseo_seosig_no) || "DDD-LMS-GY-004".equals(munseo_seosig_no))){ //--계약 품의, 체결계약서 일반 공유자 체크
			isShare = false;
			if(apr_ids.indexOf(loginUser.getLoginId()) > -1){
				isShare = true;
			}
		}
		if(!isShare)continue;
		if(isLastView)continue;
%>
		
<%-- 		next_form_no:<%=next_form_no %><br/> --%>
<%-- 		STU_GBN:<%=lmsMap.getString("STU_GBN")%><br/> --%>
<%-- 		AUTH_CD:<%=DATA_LIST.getString(i, "AUTH_CD") %><br/> --%>
<%-- 		isNextForm:<%=isNextForm%><br/> --%>
		<div id="<%=panelId%>" title="<%=iparam_munseo_seosig_nam%>" class="easyui-panel" style="padding:5px" data-options="href:'<%=href %>'<%=onLoadFn %>,collapsible:true,collapsed:<%=collapsibleYn%>"> </div>
<%		
	}
}
%>
</div>
<%if(isNextForm && StringUtil.isBlank(systemId)){ %>
<div style="border:1px solid #dcdcdc; padding:5px; margin:10px 0 5px 0;">
<jsp:include page="/ServletController" flush="false">
	<jsp:param value="SYS_FORM" 	    name="AIR_ACTION"/>
	<jsp:param value="WRITE_FORM_INCLUDE" 	    name="AIR_MODE"/>
	<jsp:param value="<%=next_form_no%>" 	name="munseo_seosig_no"/>
	<jsp:param value="<%=sol_mas_uid%>" 	name="sol_mas_uid"/>
	<jsp:param value="<%=data_doc_uid%>" 	name="data_doc_mas_uid"/>
	<jsp:param value="<%=last_doc_uid%>" 	name="doc_mas_uid"/>
	<jsp:param value="<%=last_group_uid%>" 	name="group_uid"/>
	<jsp:param value="<%=next_stu_id%>" 	name="next_stu_id"/>
	<jsp:param value="<%=stu_id%>" 	name="stu_id"/>
	<jsp:param value="<%=last_doc_stu%>" 	name="doc_stu"/>
	<jsp:param value="<%=stuNm%>" 	name="stu_nam"/>
</jsp:include>
</div>
<%} %>

<input type="hidden" id="nowProcGbn<%=sol_mas_uid%>" value="<%=lmsMap.getString("PROC_GBN")%>"/>
<input type="hidden" id="stuGbn<%=sol_mas_uid%>" value="<%=lmsMap.getString("STU_GBN")%>"/>
<script>
	//-- 패널 갯수가 많아져 스크롤이 길어 질때를 대비 해 하단으로 내려 주는 스크롤 이벤트
	var setLoadPanel<%=sol_mas_uid%> = function(){
		setTimeout(function(){
		    var offset = $("#divTODO<%=sol_mas_uid%>").offset();
		    $('html, body').animate({scrollTop : offset.top}, 500);
		}, 200);
	};
	var todoHide<%=sol_mas_uid%> = function(){
		//--투두영역 가리기 : 임시저장 상태일때만 가리기
		if("T" == "<%=last_doc_stu%>"){
			$("#divTODO<%=sol_mas_uid%>").hide();
		}
	}
	//-- todo영역 refresh
	var todoRefresh<%=sol_mas_uid%> = function(){
		var url = "/ServletController?AIR_ACTION=SYS_FORM&AIR_MODE=FORM_TODO";
		url += "&sol_mas_uid=<%=sol_mas_uid%>";
		$("#divTODO<%=sol_mas_uid%>").panel({
			href:url
			,width:'100%'		
		});
	};
	
	//-- 다음문서가 다른 솔루션 문서일경우 예) 계약 > 인장
	var openFormNoStu<%=sol_mas_uid%> = function(formNo,nextFormNo, next_stu_id, stu_gbn){
		var url = "/ServletController";
		url += "?AIR_ACTION=SYS_FORM";
		url += "&AIR_MODE=POPUP_WRITE_FORM";
		url += "&munseo_seosig_no="+nextFormNo;
		url += "&"+stu_gbn+"_munseo_seosig_no="+formNo;
		url += "&"+stu_gbn+"_sol_mas_uid=<%=sol_mas_uid%>";
		url += "&"+stu_gbn+"_gwanri_no=<%=lmsMap.getString("GWANRI_NO")%>";
		url += "&stu_id="+next_stu_id;
		url += "&next_stu_id="+next_stu_id;
		
		airCommon.openWindow(url, "1024", "650", "POPUP_WRITE_FORM", "yes", "yes", "");
	};
	
	$(function(){
<%-- 		todoRefresh<%=sol_mas_uid%>(); --%>
		
		$(window).resize(function() {
			$('.easyui-panel').panel('resize');
			$(".easyui-tabs").tabs('resize');
		});
		
	});
</script>
<br/>
<%if(StringUtil.isBlank(systemId)){ %>
<!-- 투두영역 -->
<jsp:include page="/ServletController" flush="false">
	<jsp:param value="SYS_FORM" 	    	name="AIR_ACTION" />
	<jsp:param value="FORM_TODO" 	    	name="AIR_MODE" />
	<jsp:param value="<%=sol_mas_uid%>" 	name="sol_mas_uid" />
	<jsp:param value="<%=last_doc_stu%>" 	name="doc_stu" />
	<jsp:param value="<%=stu_id%>" 			name="stu_id" />
	<jsp:param value="<%=isNextForm%>" 		name="isNextForm" />
</jsp:include>
<%} %>
<%-- 	<jsp:param value="<%=next_form_no%>" 	name="munseo_seosig_no"/> --%>
<%-- 	<jsp:param value="<%=data_doc_uid%>" 	name="data_doc_mas_uid"/> --%>
<%-- 	<jsp:param value="<%=last_doc_uid%>" 	name="doc_mas_uid"/> --%>
<%-- 	<jsp:param value="<%=last_group_uid%>" 	name="group_uid"/> --%>
<%-- 	<jsp:param value="<%=next_stu_id%>" 	name="next_stu_id"/> --%>
<%-- 	<jsp:param value="<%=stu_id%>" 	name="stu_id"/> --%>
<%-- 	<jsp:param value="<%=last_doc_stu%>" 	name="doc_stu"/> --%>
<%-- 	<jsp:param value="<%=stuNm%>" 	name="stu_nam"/> --%>