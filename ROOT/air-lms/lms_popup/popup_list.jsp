<%--
  - Author : Yang, Ki Hwa
  - Date : 2014.01.05
  - 
  - @(#)
  - Description : 법무시스템 계약리스트
  --%>
<%@page import="org.json.simple.*"%>
<%@page import="java.lang.reflect.*"%>  
<%@page import="com.emfrontier.air.lms.config.LmsConstants"%>
<%@page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%@page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@page import="com.emfrontier.air.common.bean.BeanResultMap"%>
<%@page import="com.emfrontier.air.common.config.CommonConstants" %>    
<%@page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@page import="com.emfrontier.air.common.util.HtmlUtil" %>
<%@page import="com.emfrontier.air.common.util.StringUtil" %>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
    String siteLocale = CommonProperties.getSystemDefaultLocale();
    
    if (loginUser != null) {
    	siteLocale = loginUser.getSiteLocale();
    }
    
    String systemDefaultContentUrl = CommonProperties.getSystemDefaultContentUrl();
    String CONTENT_PATH = (String)request.getAttribute(CommonConstants.CONTENT_PATH);
    String popupContentName  = StringUtil.unescape(StringUtil.convertNull(request.getParameter("popupContentName")));
    
    
    
   
    //-- 검색값 셋팅
    BeanResultMap requestMap     = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
    String pageNo               = requestMap.getString(CommonConstants.PAGE_NO);
    String pageRowSize          = requestMap.getString(CommonConstants.PAGE_ROWSIZE);
    String pageOrderByField     = requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
    String pageOrderByMethod    = requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);
    
    String schFlowCheoriYn              = StringUtil.convertNull(request.getParameter("schFlowCheoriYn"));
    String schMunseoSeosig              = StringUtil.convertNull(request.getParameter("schMunseoSeosig"));
    
    String schDocMasTit                 = StringUtil.convertNull(request.getParameter("schDocMasTit"));
    String schMuneoGwanriNo             = StringUtil.convertNull(request.getParameter("schMuneoGwanriNo"));
    String schMunseoSeosigNamko         = StringUtil.convertNull(request.getParameter("schMunseoSeosigNamko"));
    String schSysMunseoBunryuGbn01      = StringUtil.convertNull(request.getParameter("schSysMunseoBunryuGbn01"));   
    String schSysMunseoBunryuGbn02      = StringUtil.convertNull(request.getParameter("schSysMunseoBunryuGbn02"));
    String schSysMunseoBunryuGbn03      = StringUtil.convertNull(request.getParameter("schSysMunseoBunryuGbn03"));
     
    String shYoCheongIlFrom             = StringUtil.convertNull(request.getParameter("shYoCheongIlFrom"));
    String shYoCheongIlTo               = StringUtil.convertNull(request.getParameter("shYoCheongIlTo"));
    String shYoCheongBuSeo              = StringUtil.convertNull(request.getParameter("shYoCheongBuSeo"));
    String shGyeYagSangDaeBang          = StringUtil.convertNull(request.getParameter("shGyeYagSangDaeBang"));
    String shYoCheongJa                 = StringUtil.convertNull(request.getParameter("shYoCheongJa"));
    String shDamDangJa                  = StringUtil.convertNull(request.getParameter("shDamDangJa"));
    String shJinHaengSangTae            = StringUtil.convertNull(request.getParameter("shJinHaengSangTae"));
    String shGyeYagMyeong               = StringUtil.convertNull(request.getParameter("shGyeYagMyeong"));
    String shEoneo                      = StringUtil.convertNull(request.getParameter("shEoneo"));
    String shHoesa                      = StringUtil.convertNull(request.getParameter("shHoesa"));
    String shGyeyagYH                   = StringUtil.convertNull(request.getParameter("shGyeyagYH"));
    String shSujeongChegyeol            = StringUtil.convertNull(request.getParameter("shSujeongChegyeol"));
    String schGuBun                     = StringUtil.defaultIfEmpty(request.getParameter("schGuBun"), "My");
    
    
    
    //월별 계약/자문 실적 통계 추가에서 해당 월에 대한 리스트만 보여주기 위해 쓰는 변수
    String date                      = StringUtil.convertNull(request.getParameter("date"));
    String side                      = StringUtil.convertNull(request.getParameter("side"));
    String yhcod                      = StringUtil.convertNull(request.getParameter("yhcod"));
    String yhcod2                      = StringUtil.convertNull(request.getParameter("yhcod2"));
    
    
    
    String menuParamMunseoBunryuGbnCod1 = requestMap.getString("MENUPARAMMUNSEOBUNRYUGBNCOD1");
    String menuParamMunseoSeosikGbn     = requestMap.getString("MENUPARAMMUNSEOSEOSIKGBN");
    
    if(StringUtil.isBlank(menuParamMunseoBunryuGbnCod1)){
    	menuParamMunseoBunryuGbnCod1 = "SYS_MUNSEO_BUNRYU_GBN_LMS";
    }
    
    
    //-- 결과값 셋팅
    BeanResultMap resultMap             = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);  
    
    // 리스트 컬럼
    String   finalListColumn 			= resultMap.getString("FINAL_LIST_COLUMN");    
    String[] finalListColumnArray 		= StringUtil.split(finalListColumn, "|");
    
    // 상태코드
    SQLResults statCdList = resultMap.getResult("STAT_CODE_LIST");
    String statCdStr = StringUtil.getCodestrFromSQLResults(statCdList, "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));   
    
    // 회사코드
    SQLResults hoesaCdList = resultMap.getResult("HOESA_CODE_LIST");
    String hoesaCdStr = StringUtil.getCodestrFromSQLResults(hoesaCdList, "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));   
    
    // 계약유형코드
    SQLResults yuhyeongCdList = resultMap.getResult("GYEYAG_YUHYEONG_CODE_LIST");
    String yuhyeongCdStr = StringUtil.getCodestrFromSQLResults(yuhyeongCdList, "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));   
    
    // 언어코드
    SQLResults eoneoCdList = resultMap.getResult("EONEO_CODE_LIST");
    String eoneoCdStr = StringUtil.getCodestrFromSQLResults(eoneoCdList, "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));   
    
    
    String actionCode           = resultMap.getString(CommonConstants.ACTION_CODE);
    String modeCode             = resultMap.getString(CommonConstants.MODE_CODE);
    String contentName          = (String)StringUtil.convertNull(request.getAttribute(CommonConstants.CONTENT_NAME));
    
    String jsonDataUrl = "/ServletController"
            + "?AIR_ACTION="+ actionCode  
            + "&AIR_MODE=JSON_LIST"
    		+ "&date="+ date
    		+ "&side="+ side
    		+ "&yhcod="+ yhcod
    		+ "&yhcod2="+ yhcod2;
    
    
//     // 법무팀 여부
    boolean legalTeamFlag = LmsUtil.isBeobmuTeamUser(loginUser);
    
//     // 권한별 상태코드 추가
//     if(legalTeamFlag){
//         // 법무팀일 경우
//         statCdStr += "^"+LmsConstants.STAT_GY_JH_DD +"|" + StringUtil.getLocaleWord("L.진행중",siteLocale);        
//     }else{
//         // 일반 요청자일 경우
//         statCdStr += "^"+LmsConstants.STAT_GY_JH_YC +"|" + StringUtil.getLocaleWord("L.진행중",siteLocale);        
//     }
%>
<script type="text/javascript">
 /**
  * 상세보기 페이지로 이동
  */
 function goView(index,data) {
 	var uid = data.UIROE_NO;
     var id = data.GWANRI_NO;        
     var title = data.GYEYAG_TIT;
     var title_no = "";

     if(id == ''){
     	//title_no = "["+uid+"]"+title;
     	title_no = uid;
     } else  {
     	//title_no = "["+id+"]"+title;
     	title_no = id;
     }             
     
     if ($("#listTabsLayer").tabs("exists", title_no)) {
         $("#listTabsLayer").tabs("close", title_no);
     } 

     var content = "<iframe name=\"listTabsFrame-"+ title_no +"\" id=\"listTabsFrame-"+ title_no +"\""
			  	 + " scrolling=\"no\" frameborder=\"0\""				
				 + " style=\"border:0;width:100%;height:0px\""
				 + " src=\"/ServletController?AIR_ACTION=LMS_GY_TEP&AIR_MODE=INDEX&sol_mas_uid="+ data.SOL_MAS_UID +"&title_no="+ title_no +"\""					
				 + "></iframe>";		     
                 
     $("#listTabsLayer").tabs("add", {   
         id:'listTabs-'+title_no,
         title:title_no,
         content:content,
         closable:true,
         iconCls:'icon-document',
         style:{paddingTop:'5px'}
     });         
 }
 
 /**
  * 검색 수행
  */ 
 function doSearch(frm, isCheckEnter) {
 	if (isCheckEnter && event.keyCode != 13) {         
         return;
     }
 	
 	$("#listTable").datagrid("load", getSearchQueryParams());
 };
 
 /**
  * 검색 쿼리 파라메터 반환 
  */
 function getSearchQueryParams() {
 	return {
         shYoCheongIlFrom : $("#shYoCheongIlFrom").val(),
         shYoCheongIlTo : $("#shYoCheongIlTo").val(),
         shYoCheongBuSeo : $("#shYoCheongBuSeo").val(),
         shGyeYagSangDaeBang : $("#shGyeYagSangDaeBang").val(),
         shYoCheongJa : $("#shYoCheongJa").val(),
         shDamDangJa : $("#shDamDangJa").val(),
         shJinHaengSangTae : $("#shJinHaengSangTae").val(),
         shGyeYagMyeong : $("#shGyeYagMyeong").val(),
//          date : $("#date").val(),
<% 
if (legalTeamFlag) { 
%>
         schGuBun : $("input[name=schGuBun]:checked").val(), 
         shEoneo : $("#shEoneo").val(),
         shHoesa : $("#shHoesa").val(),
         shGyeyagYH : $("#shGyeyagYH").val(),
         shSujeongChegyeol : $("#shSujeongChegyeol").val()
<% 
} else {
%>
         schGuBun : $("input[name=schGuBun]:checked").val()
<% 
}
%>
     };
 }
 
 /**
  * 검색항목 초기화
  */
 function doReset(frm) {
 	if (confirm("<%=StringUtil.getScriptMessage("M.ALERT_RESETSEARCHITEMS",siteLocale)%>")) {
 		frm.reset();
 	}
 }
 
 /**
  * 정렬 이벤트 핸들러
  */
 function onSort(sort, order) {
 	$("input[name=<%=CommonConstants.PAGE_ORDERBY_FIELD%>]").val(sort);
 	$("input[name=<%=CommonConstants.PAGE_ORDERBY_METHOD%>]").val(order);
 }
 
 /**
  * 탭 코드 값으로 해당 탭을 선택된 상태로 셋팅
  */
 function listTabs_setSelected(tabCode) {
     var title = $("#listTabs-"+ tabCode).panel("options").title;
     $("#listTabsLayer").tabs("select", title);
 }

 /**
  * 탭 코드 값으로 탭을 변경하고, 컨텐츠 경로 값이 있으면 경로도 함께 변경
  */
 function listTabs_change(tabCode, src) {
     if (tabCode == "LIST") {
         doSearch(document.form1);
     } else {
         if (src) {
             $("#listTabsFrame-"+ tabCode).attr("src", src);
         }
     }
     
     tepTabs_setSelected(tabCode);
 }

 /**
  * 탭 코드 값으로 해당 탭 닫기
  */
 function listTabs_close(tabCode) {
     $("#listTabsLayer").tabs("close", title);
 }
 
 /**
  * onload event handler
  */
 $(document).ready(function() {		
 	$("#listTable").datagrid({
 		singleSelect:true,
		striped:true,
		fitColumns:false,
		rownumbers:true,
		multiSort:true,
		pagination:true,
		pagePosition:'bottom',	
		pageSize:<%=pageRowSize%>,
		nowrap:false,
 		url:'<%=jsonDataUrl%>',
 		method:"post",				            	             
      	queryParams:getSearchQueryParams(),
      	onClickRow:function(rowIndex,rowData) {
 			goView(rowIndex,rowData);
       	},
		onSortColumn:function(sort, order) {
			onSort(sort, order);
		}
 	});
 	
 	$("#listTabsLayer").tabs({		
		onSelect:function(title,index){
			if (0 == index) {
				doSearch(document.form1);
			}
		},
		onClose:function(title,index){			
			doSearch(document.form1);			
		}
	});
 });
 </script>
 
<div id="listTabsTools-LIST">
	<a href="javascript:void(0)" onclick="doSearch(document.form1)" class="icon-mini-refresh"></a>
</div>

<div id="listTabsLayer" class="easyui-tabs" data-options="border:false,plain:true" style="width:auto;height:auto">
	<div id="listTabs-LIST" title="계약검토 리스트" data-options="tools:'#listTabsTools-LIST'" style="padding-top:5px">
		<form id="form1" name="form1" method="post" onsubmit="return false;">	
	    <input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	    <input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
	    <input type="hidden" name="<%=CommonConstants.PAGE_NO%>" value="<%=pageNo%>" />
	    <input type="hidden" name="<%=CommonConstants.PAGE_ROWSIZE%>" value="<%=pageRowSize%>" />
	    <input type="hidden" name="<%=CommonConstants.PAGE_ORDERBY_FIELD%>" value="<%=pageOrderByField%>" />
	    <input type="hidden" name="<%=CommonConstants.PAGE_ORDERBY_METHOD%>" value="<%=pageOrderByMethod%>" />
	    <input type="hidden" name="date" value="<%=date%>" />
	    <input type="hidden" name="side" value="<%=side%>" />
	    <input type="hidden" name="yhcod" value="<%=yhcod%>" />
	    <input type="hidden" name="yhcod2" value="<%=yhcod2%>" />
	    
	    <input type="hidden" name="doc_flow_uid" />
	    <input type="hidden" name="doc_mas_uid" />
	    <input type="hidden" name="sol_mas_uid" />
	    <input type="hidden" name="gwanri_mas_uid" />
	    <input type="hidden" name="sys_gbn_code_id" />
	    <input type="hidden" name="eobmu_gbn_code_id" />
	    <input type="hidden" name="xls_jeoe_columns" />	
	    
		<div class="buttonlist">
		    <div class="right">		
		    	<script>
				/*
				 * 엑셀다운로드
				 */
				function doExcelDown(frm){
					frm.action = "/ServletController";
					frm.<%=CommonConstants.ACTION_CODE%>.value = "<%=actionCode%>";
					frm.<%=CommonConstants.MODE_CODE%>.value = "JSON_EXCEL";
					frm.target = "airBackgroundProcessFrame";
					frm.submit();
				}
				</script>
				<span class="ui_btn medium icon"><span class="save"></span><a href="javascript:void(0)" onclick="doExcelDown(document.form1)"><%=StringUtil.getLocaleWord("B.엑셀저장", siteLocale)%></a></span>
			</div>						
		</div>	
		
		<table id="listTable" style="width:auto;height:auto">		
		<thead>
		<tr>	
			<th data-options="field:'SOL_MAS_UID',width:0,hidden:true"></th>
			<th data-options="field:'GWANRI_MAS_UID',width:0,hidden:true"></th>
			<th data-options="field:'SYS_GBN_CODE_ID',width:0,hidden:true"></th>
			<th data-options="field:'EOBMU_GBN_CODE_ID',width:0,hidden:true"></th>					
			<th data-options="field:'TITLE_NO',width:0,hidden:true"></th>
			<th data-options="field:'UIROE_NO',width:0,hidden:true"></th>   		  
<%								  
Class label = Class.forName("com.emfrontier.air.lms.resource.list.LmsGyListLabel");
Field[] fields = label.getFields();
 
for (int i=0; i<finalListColumnArray.length; i++) {
	Field fld = label.getField(finalListColumnArray[i].toUpperCase());
	String options = StringUtil.getLocaleWord(fld.get(label).toString(),"OPTIONS");
	options = (!"".equals(options) ? ","+options : "");
%>
			<th data-options="field:'<%=finalListColumnArray[i].toUpperCase()%>',width:<%=StringUtil.getLocaleWord(fld.get(label).toString(),"WIDTH") %>,halign:'<%=StringUtil.getLocaleWord(fld.get(label).toString(),"HALIGN") %>',align:'<%=StringUtil.getLocaleWord(fld.get(label).toString(),"ALIGN") %>'<%=options%>"><%=StringUtil.convertForView(StringUtil.getLocaleWord(fld.get(label).toString(),siteLocale))%></th>									
<%
}
%>		
		</tr>
		</thead>
		</table>				
		</form>
	</div>
</div>