<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Locale"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="java.lang.reflect.*" %>
<%@ page import="com.emfrontier.air.lms.config.LmsConstants"%>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();
	
	//-- 검색값 셋팅
	BeanResultMap requestMap = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
    String pageNo               	= requestMap.getString(CommonConstants.PAGE_NO);
    String pageRowSize          = requestMap.getString(CommonConstants.PAGE_ROWSIZE);
    String pageOrderByField    	= requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
    String pageOrderByMethod	= requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);	
	String menuNm					= requestMap.getString(siteLocale);
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	
	SQLResults COST_LIST = resultMap.getResult("COST_LIST");
			
	//-- 파라메터 셋팅
	String actionCode	= resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode	= resultMap.getString(CommonConstants.MODE_CODE);
	
	//-- 코드정보 문자열 셋팅
	String schYuHyeongStr = "|"+StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale)+"^GY|"+StringUtil.getLocaleWord("L.계약",siteLocale)+"^JM|"+StringUtil.getLocaleWord("L.자문",siteLocale)+"^SS|"+StringUtil.getLocaleWord("L.소송",siteLocale);
	String JIGEUB_DAESANG_NAMESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("HOESA_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale));
%>
<div id="listTabsLayer" class="easyui-tabs" data-options="border:false,plain:true" style="width:auto;height:auto">
	<div id="listTabs-LIST" title="<%=menuNm %>" data-options="tools:'#listTabsTools-LIST'" style="padding-top:5px">
	
<form name="form1" method="post">
	<input type="hidden" name="<%=siteLocale %>" value="<%=requestMap.getString("MENU_NAME_KO")%>" />
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
		
	<table class="box">
	<tr>
		<td class="corner_lt"></td>
		<td class="border_mt"></td>
		<td class="corner_rt"></td>
	</tr>
	<tr>
		<td class="border_lm"></td>
		<td class="body">
			<table>
				<colgroup>
					<col style="width:8%" />
					<col style="width:20%" />
					<col style="width:10%" />
					<col style="width:20%" />
					<col style="width:10%" />
					<col style="width:auto" />
					<col style="width:160px" />
				</colgroup>
				<tr>
					<th><%=StringUtil.getLocaleWord("L.지급품의연월",siteLocale) %></th>
					<td>
						<select name="schYear" data-type="search" style="width:70px;">
							<%=HtmlUtil.getSelectboxCalendar("YEAR", 2018, -1, requestMap.getString("SCHYEAR")) %>
						</select>
						<select name="schMonth" data-type="search" style="width:50px;">
							<%=HtmlUtil.getSelectboxCalendar("MONTH", 1, 12, requestMap.getString("SCHMONTH")) %>
						</select>
					</td>
					<th><%=StringUtil.getLocaleWord("L.법무법인",siteLocale) %></th>
					<td><input type="text" name="JIGEUB_DAESANG_NAM" data-type="search" maxlength="30" class="text width_max" /></td>
					<th><%=StringUtil.getLocaleWord("L.구분",siteLocale) %></th>
					<td><%=HtmlUtil.getSelect(request, true, "schYuHyeong", "schYuHyeong", schYuHyeongStr, requestMap.getString("SCHYUHYEONG"), "style=\"width:100%;\" class=\"select\"")%></td>  
					<td style="text-align:center;">
					    <span class="ui_btn medium icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="doReset(document.form1);"><%=StringUtil.getLocaleWord("B.INIT",siteLocale)%></a></span>
						<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:doSearch(document.form1);"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>						
					</td>
				</tr>
				<tr>
				</tr>
			</table>
	</td>
		<td class="border_rm"></td>
	</tr>
	<tr>
		<td class="corner_lb"></td><td class="border_mb"></td><td class="corner_rb"></td>
	</tr>							
	</table>
	<div class="buttonlist">
	    <div class="left">
			<span style="color:red">※ 지급품의연월 : 비용 지급품의연월 기준입니다.</span>
		</div>
		<div class="right">
	    	<script>
			/*
			 * 엑셀다운로드
			 */
			function doExcelDown(frm){
				frm.action = "/ServletController";
				frm.<%=CommonConstants.ACTION_CODE%>.value = "<%=actionCode%>";
				frm.<%=CommonConstants.MODE_CODE%>.value = "COST_BY_LAWFIRM_JSON_EXCEL";
				frm.target = "airBackgroundProcessFrame";
				frm.submit();
			}
			</script>
			<span class="ui_btn medium icon"><span class="save"></span><a href="javascript:void(0)" onclick="doExcelDown(document.form1)"><%=StringUtil.getLocaleWord("B.엑셀저장", siteLocale)%></a></span>		
		</div>
	</div>
	

	<table class="basic" id="costTable">
		<tr>
			<th style="text-align:center"><%=StringUtil.getLocaleWord("L.Num",siteLocale) %></th>
			<th style="text-align:center"><%=StringUtil.getLocaleWord("L.법무법인",siteLocale) %></th>
			<th style="text-align:center"><%=StringUtil.getLocaleWord("L.구분",siteLocale) %></th>
			<th style="text-align:center"><%=StringUtil.getLocaleWord("L.지급구분",siteLocale) %></th>
			<th style="text-align:center"><%=StringUtil.getLocaleWord("L.건",siteLocale) %></th>
			<th style="text-align:center"><%=StringUtil.getLocaleWord("L.총액",siteLocale) %></th>
			<th style="text-align:center"><%=StringUtil.getLocaleWord("L.평균",siteLocale) %></th>
		</tr>
<%
	if(COST_LIST != null && COST_LIST.getRowCount() > 0){
		int rowCnt = 1;
		String sumRow =  "<b>"+ StringUtil.getLocaleWord("L.전체",siteLocale)+"</b>";
		String printSumRow = "";
		for(int i=0; i< COST_LIST.getRowCount(); i++){ 
			
           if(sumRow.equals(COST_LIST.getString(i, "GBN")) || sumRow.equals(COST_LIST.getString(i, "JIGEUB_GUBUN"))){
        	   
        	   if(sumRow.equals(COST_LIST.getString(i, "JIGEUB_DAESANG_COD"))) {
        		   printSumRow = COST_LIST.getString(i, "JIGEUB_DAESANG_COD");
        	   } else {
        		   printSumRow = COST_LIST.getString(i, "JIGEUB_DAESANG_NAME");
        	   }
%>
       	<tr title="SUM ROW">
            <td style="text-align:center;"><%=rowCnt %></td>
			<td style="text-align:center;"><%=printSumRow %></td>
			<td style="text-align:center;"><%=COST_LIST.getString(i, "GBN")%></td>
			<td style="text-align:center;"><%=COST_LIST.getString(i, "JIGEUB_GUBUN")%></td>
			<td style="text-align:right;"><b><%=StringUtil.getFormatCurrency(COST_LIST.getString(i, "TOT_CNT"),0) %></b></td>
			<td style="text-align:right;"><b><%=StringUtil.getFormatCurrency(COST_LIST.getString(i, "JIGEUB_BIYONG"),0) %></b></td>
			<td style="text-align:right;"><b><%=StringUtil.getFormatCurrency(COST_LIST.getString(i, "JIGEUB_BIYONG_AVG"),0) %></b></td> 
		</tr>
<%    
           }else{
%>
        <tr>
            <td style="text-align:center;"><%=rowCnt %></td>
			<td style="text-align:center;"><%=COST_LIST.getString(i, "JIGEUB_DAESANG_NAME") %></td>
			<td style="text-align:center;"><%=COST_LIST.getString(i, "GBN")%></td>
			<td style="text-align:center;"><%=COST_LIST.getString(i, "JIGEUB_GUBUN")%></td>
			<td style="text-align:right;"><%=StringUtil.getFormatCurrency(COST_LIST.getString(i, "TOT_CNT"),0) %></td>
			<td style="text-align:right;"><%=StringUtil.getFormatCurrency(COST_LIST.getString(i, "JIGEUB_BIYONG"),0) %></td>
			<td style="text-align:right;"><%=StringUtil.getFormatCurrency(COST_LIST.getString(i, "JIGEUB_BIYONG_AVG"),0) %></td> 
		</tr>
		<% }
		 if(sumRow.equals(COST_LIST.getString(i, "GBN"))  ){ 
	            rowCnt++;
          }             	
            
		}
	}else{
%>
		<tr>
			<td colspan="7" align="center"><%=StringUtil.getLocaleWord("M.검색결과가없습니다",siteLocale) %></td>
		</tr>
<%		
	}
%>		
	</table>
</form>
</div>
</div>
<script>
function doReset(frm) {
	if (confirm("<%=StringUtil.getScriptMessage("M.ALERT_RESETSEARCHITEMS",siteLocale) %>")) {
		frm.reset();
	    $("#schYear").val("<%=Calendar.getInstance().get(Calendar.YEAR) %>");
		$("#schYuHyeong").val("");
		$("#schHoesaCd").val("");
	}
}

/**
 * 검색 수행
 */	
function doSearch(frm, isCheckEnter){
	if (isCheckEnter && event.keyCode != 13) {			
		return;
	}
	
	frm.action = "/ServletController";
	frm.<%=CommonConstants.ACTION_CODE%>.value = "<%=actionCode%>";
	frm.<%=CommonConstants.MODE_CODE%>.value = "<%=modeCode%>";
	frm.target = "_self";
	frm.submit();
}

$(function(){
	$('#costTable').rowspan2(0);
	$('#costTable').rowspan2(1);
	$('#costTable').rowspan2(2);
	$('#costTable').rowspan2(3);
});

/* 
 * 
 * 같은 값이 있는 열을 병합함
 * 
 * 사용법 : $('#테이블 ID').rowspan(0);
 * 
 */  
$.fn.rowspan2 = function(colIdx, isStats) {       
    return this.each(function(){      
        var that;    
        $('tr', this).each(function(row) {      
            $('td:eq('+colIdx+')', this).filter(':visible').each(function(col) {
                if ($(this).html() == $(that).html()&& ((!isStats || isStats && $(this).prev().html() == $(that).prev().html()) 
                  	&& $(this).html() !="<%=StringUtil.getLocaleWord("L.전체",siteLocale) %>" )) { // 값이 '소계' 이면 rowspan 안함.   
                    rowspan = $(that).attr("rowspan") || 1;
                    rowspan = Number(rowspan)+1;
                    
                    $(that).attr("rowspan",rowspan);
                    // do your action for the colspan cell here            
                    $(this).hide();
                    
                    //$(this).remove(); 
                    // do your action for the old cell here
                } else {            
                    that = this;        
                    if( $(this).html() !="<%=StringUtil.getLocaleWord("L.전체",siteLocale) %>" ){
                    	//alert("전체");
                    } 
                }     
                
                $('#costTable').colspan(row); // row 돌때 마다 colspan
                 
                // set the that if not already set
                that = (that == null) ? this : that;
                
            });     
        });    
    });  
};  


/* 
 * 
 * 같은 값이 있는 행을 병합함
 * 
 * 사용법 : $('#테이블 ID').colspan (0);
 * 
 */  
$.fn.colspan = function(rowIdx) {
 //alert("col  :  "+rowIdx);
    return this.each(function(){
        var that;
        $('tr', this).filter(":eq("+rowIdx+")").each(function(row) {
            $(this).find('td').filter(':visible').each(function(col) {
                if ($(this).html() == $(that).html()) {
                    colspan = $(that).attr("colSpan") || 1;
                    colspan = Number(colspan)+1;
                    if( col <3){
                        $(that).attr("colSpan",colspan);
                        $(this).hide(); // .remove();  
                    }
                } else {
                    that = this;
                }
                // set the that if not already set
                that = (that == null) ? this : that;
            });
        });
    });
} 
</script>