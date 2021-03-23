<%--
  - Author : Yang, Ki Hwa
  - Date : 2014.02.21
  - 
  - @(#)
  - Description : 법무시스템 공용 결재문서리스트
  --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.emfrontier.air.lms.config.LmsConstants" %>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap" %>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%
//-- 로그인 사용자 정보 셋팅
SysLoginModel loginUser     = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
String siteLocale           = loginUser.getSiteLocale();

//-- 검색값 셋팅
BeanResultMap requestMap     = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
String pageNo               = requestMap.getString(CommonConstants.PAGE_NO);
String pageRowSize          = requestMap.getString(CommonConstants.PAGE_ROWSIZE);
String pageOrderByField     = requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
String pageOrderByMethod    = requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);

//-- 결과값 셋팅
BeanResultMap resultMap     = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
String solMasUid            = StringUtil.convertNull(resultMap.getString("SOL_MAS_UID"));
String munseo_seosig_no         = StringUtil.convertNull(resultMap.getString("MUNSEO_SEOSIG_NO"));
String munseo_bunryu_gbn_cod3   = StringUtil.convertNull(resultMap.getString("MUNSEO_BUNRYU_GBN_COD3"));

String actionCode = "";
String modeCode = "";
String shGubun = "";
String shSangTae = StringUtil.convertNull(request.getParameter("shSangTae"));
String schTitle = "";

//-- 파라메터 셋팅
String contentName          = (String)StringUtil.convertNull(request.getAttribute(CommonConstants.CONTENT_NAME));

String jsonDataUrl 
    = "/ServletController"
    + "?AIR_ACTION=SYS_APR"  
    + "&AIR_MODE=JSON_LIST";    

String tabCode = "GYC";

if("GA".equals(munseo_bunryu_gbn_cod3)){
    tabCode = "GAS";   
}

String 전체 = StringUtil.getLocaleWord("L.CBO_ALL",siteLocale);
String 결재요청 = StringUtil.getLocaleWord("L.결재요청",siteLocale);
String 결재대상 = StringUtil.getLocaleWord("L.결재대상",siteLocale);
String 결재완료 = StringUtil.getLocaleWord("L.결재완료",siteLocale);
String 제목 = StringUtil.getLocaleWord("L.제목",siteLocale);
String 의뢰자 = StringUtil.getLocaleWord("L.의뢰자",siteLocale);
String 요청자 = StringUtil.getLocaleWord("L.요청자",siteLocale);
String 요청일 = StringUtil.getLocaleWord("L.요청일",siteLocale);
String 처리상태 = StringUtil.getLocaleWord("L.처리상태",siteLocale);

String shGubunStr = "|"+전체+"^GY|"+StringUtil.getLocaleWord("L.계약",siteLocale)+"^JM|"+StringUtil.getLocaleWord("L.자문",siteLocale);
String shSangtaeStr = "W|"+결재대상+"^Y|"+결재완료+"^S|"+결재요청;
//	String shSangtaeStr = "Y|"+결재완료; //대림삼업 전용 - 전자결재 연동으로 결재대상 비활성화
%>
<!-- // Content // -->
<form id="form1" name="form1" method="post" onsubmit="return false;">   
    <input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
    <input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
    <input type="hidden" name="<%=CommonConstants.PAGE_NO%>" value="<%=pageNo%>" />
    <input type="hidden" name="<%=CommonConstants.PAGE_ROWSIZE%>" value="<%=pageRowSize%>" />
    <input type="hidden" name="<%=CommonConstants.PAGE_ORDERBY_FIELD%>" value="<%=pageOrderByField%>" />
    <input type="hidden" name="<%=CommonConstants.PAGE_ORDERBY_METHOD%>" value="<%=pageOrderByMethod%>" />
     
    <table class="box">
        <tr>
            <td class="corner_lt"></td><td class="border_mt"></td><td class="corner_rt"></td>
        </tr>
        <tr>
            <td class="border_lm"></td>
            <td class="body">
                <table>
                <colgroup>
                    <col style="width:10%" />
                    <col style="width:20%" />
                    <col style="width:10%" />
                    <col style="width:20%" />
                    <col style="width:10%" />
                    <col style="width:auto" />
                    <col style="width:10%" />
                </colgroup>
                <tr>
                    <th><%=StringUtil.getLocaleWord("L.구분",siteLocale)%></th>
                    <td><%=HtmlUtil.getSelect(request, true, "stu_gbn", "stu_gbn", shGubunStr, shGubun, "class=\"select\" data-type=\"search\" style='width:100%;'")%></td>
                    <th><%=처리상태 %></th>
                    <td>
                    	<%=HtmlUtil.getSelect(request, true, "apr_stu", "apr_stu", shSangtaeStr, StringUtil.convertNullDefault(shSangTae, "W"), "onChange=\"doSearch()\" class=\"select\" data-type=\"search\" style='width:100%;'")%>
                    </td>
                    <th><%=StringUtil.getLocaleWord("L.제목",siteLocale)%></th>
                    <td><input type="text" class="text width_max" name="title" id="title" value="<%=StringUtil.convertForInput(schTitle) %>" data-type="search" onkeydown="doSearch(document.form1, true)" /></td>
                    <td rowspan="4" class="verticalContainer">
                        <span class="ui_btn medium icon"><span class="search"></span><input type="button" onclick="doSearch(document.form1);" value="<%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%>"></span>
                    </td>
                </tr>
                </table>
            </td>
            <td class="border_rm"></td>
        </tr>
        <tr>
            <td class="corner_lb"></td>
            <td class="border_mb"></td>
            <td class="corner_rb"></td>
        </tr>                           
    </table>
 </form>       
<%--
    <div id="listToolbar" style="height:auto">
        <table style="border:0;width:100%;">
        <colgroup>          
            <col style="width:90%" />
            <col style="width:10%" />
        </colgroup>
        <tr>
            <th style="text-align:left"></th>
            <td style="text-align:right">
            </td>
        </tr>
        </table>    
    </div>
 --%>
    <br>            
    <table id="listTable" style="width:auto;height:auto">       
        <thead>
        <tr>    
            <th data-options="field:'SOL_MAS_UID',width:0,hidden:true"></th>
            <th data-options="field:'APR_NO',width:0,hidden:true"></th>
            <th data-options="field:'GBN_NAM',width:100,halign:'center',align:'center'"><%=StringUtil.getLocaleWord("L.구분",siteLocale)%></th>      
            <th data-options="field:'TITLE',width:500,halign:'center',align:'left'"><%=제목 %></th>
            <th data-options="field:'MUNSEO_SEOSIG_NAM_KO',width:100,halign:'center',align:'center'">결재문서</th>
            <th data-options="field:'REG_NM',width:100,halign:'center',align:'center'"><%=요청자 %></th>
            <th data-options="field:'REG_DTE',width:140,halign:'center',align:'center'"><%=요청일 %></th>
            <th data-options="field:'APR_STU_NM',width:70,halign:'center',align:'center'"><%=처리상태 %></th>
           <!--  <th data-options="field:'NO_APVL',width:0,hidden:true"></th> 대림산업 전자결재연동으로 추가됨 -->
        </tr>
        </thead>
    </table>
	<div class="norecords" style="text-align:right">
		<br/>
		<%=HtmlUtil.getInputCheckbox(request,  true, "deadline" , "toDate|"+StringUtil.getLocaleWord("L.오늘창닫기",siteLocale) ,"" ,"onclick=\"javascript:closeWin(this.value)\"", "style=\"color:blue;\"")%>	
	</div>
<script type="text/javascript">
/**
 * 오늘 하루 창 닫기
 */
function closeWin(seq) {
	airCommon.setCookie(seq,"GyealOk",1);
	self.close();
}

/**
 * 상세보기 페이지로 이동
 */
function goView(index,data) {
	var sol_mas_uid = data.SOL_MAS_UID;
    var url = "/ServletController";
    url += "?AIR_ACTION=SYS_APR_TEP";  
   	url += "&AIR_MODE=INDEX";  
   	url += "&apr_no="+ data.APR_NO;  
   	url += "&sol_mas_uid="+ data.SOL_MAS_UID;  
   	url += "&view_doc_mas_uid="+ data.DOC_MAS_UID;  

   	<%--
    var callbackFunction = "opener.doSearch(null, false); self.close();";
    
    airLms.popupTepIndex(doc_mas_uid, sol_mas_uid, doc_flow_uid, callbackFunction); 
    
   	대림산업 전용 - 전자결재연동  
    var no_apvl = data.NO_APVL;
	var url = "https://portal.daelim.co.kr/eNovator/WF/WebPage/ApprovalForms/Forms/F_DraftERP_Read.aspx?pid="+ no_apvl;			
	<%if ("DEV".equals(CommonProperties.getSystemMode())){%>  
	url = "https://portalssl.daelim.co.kr/eNovator/WF/WebPage/ApprovalForms/Forms/F_DraftERP_Read.aspx?pid="+ no_apvl; /* 테스트용  */
	<%}%>
 	--%>
    airCommon.openWindow(url, "1024", "700", "TEP_"+ sol_mas_uid, "yes", "yes"); 
}

/**
 * 검색 수행
 */ 
function doSearch(frm, isCheckEnter) {
    if (isCheckEnter && event.keyCode != 13) {          
        return;
    }
    
    $("#listTable").datagrid("load", airCommon.getSearchQueryParams());    
}

$(document).ready(function() {
    $("#listTable").datagrid({
        onClickRow:function(rowIndex,rowData) {
            goView(rowIndex,rowData);
        },      
        singleSelect:true,
        striped:true,
        fitColumns:true,
        rownumbers:true,
        multiSort:true,
        pagination:true,
        pagePosition:'bottom',
        url:"<%=jsonDataUrl%>",  
        queryParams:airCommon.getSearchQueryParams(),
        method:"post",
        toolbar:"#listToolbar"      
    });
    $(window).resize(function(){
		 airCommon.gridResize();
	});
});
</script>