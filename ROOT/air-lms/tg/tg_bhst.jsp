<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
String siteLocale			= loginUser.getSiteLocale();

//-- 검색값 셋팅
BeanResultMap requestMap 	= (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
String menuNm						= requestMap.getString(siteLocale);
String schYuHyeong				= requestMap.getString("SCHYUHYEONG");
String schDateFrom				= requestMap.getString("SCHDATEFROM");
String schDateTo					= requestMap.getString("SCHDATETO");
String schName					= requestMap.getString("SCHNAME");
String schbeobryulsamusoCod	= requestMap.getString("SCHBEOBRYULSAMUSOCOD");

//-- 결과값 셋팅
BeanResultMap resultMap 			= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	
//-- 파라메터 셋팅
String actionCode 					= resultMap.getString(CommonConstants.ACTION_CODE);
String modeCode 					= resultMap.getString(CommonConstants.MODE_CODE);

//-- 코드정보 문자열 셋팅
//법률사무소 코드
String beobryulsamusoCdStr 	= StringUtil.getCodestrFromSQLResults(resultMap.getResult("BEOBRYULSAMUSO_CODE_LIST"), "CODE,NAME_KO", "|" + StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale));

//리스트 데이터
SQLResults BHST = resultMap.getResult("BHST");

String 기간 			= StringUtil.getLocaleWord("L.기간",siteLocale);
String 번호 			= StringUtil.getLocaleWord("L.번호",siteLocale);
String 법무법인			= StringUtil.getLocaleWord("L.법무법인",siteLocale);
String 유형 			= StringUtil.getLocaleWord("L.유형",siteLocale);
String 소속 			= StringUtil.getLocaleWord("L.소속",siteLocale);
String 이름 			= StringUtil.getLocaleWord("L.이름",siteLocale);
String 평점 			= StringUtil.getLocaleWord("L.평점",siteLocale);
String 검토일 			= StringUtil.getLocaleWord("L.검토일",siteLocale);
String 전체 			= StringUtil.getLocaleWord("L.CBO_ALL",siteLocale);
String 계약 			= StringUtil.getLocaleWord("L.계약",siteLocale);
String 자문 			= StringUtil.getLocaleWord("L.자문",siteLocale);
String 소송 			= StringUtil.getLocaleWord("L.소송",siteLocale);
String 분쟁 			= StringUtil.getLocaleWord("L.분쟁",siteLocale);
String No           = StringUtil.getLocaleWord("L.No",siteLocale);
String 검색결과가없습니다 		= StringUtil.getLocaleWord("M.검색결과가없습니다",siteLocale);
String schYuHyeongStr = "|"+전체+"^GY|"+계약+"^JM|"+자문+"^SS|"+소송+"^SS|"+분쟁;
%>
<div id="listTabsLayer" class="easyui-tabs" data-options="border:false,plain:true" style="width:auto;height:auto">
	<div id="listTabs-LIST" title="<%=menuNm %>" data-options="tools:'#listTabsTools-LIST'" style="padding-top:5px">
<form name="form1" method="post">	
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
	<input type="hidden" name="<%=siteLocale %>" value="<%=menuNm%>" />
			
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
					<col style="width:8%;" />
					<col style="width:23%;" />
					<col style="width:8%;" />
					<col style="width:14%;" />
					<col style="width:10%;" />
					<col style="width:14%;" />
					<col style="width:auto;" />
				</colgroup>
				<tr>
					<th><%=기간 %></th>
					<td><%=HtmlUtil.getInputCalendar(request, true, "schDateFrom", "schDateFrom", schDateFrom, "")%> ~ <%=HtmlUtil.getInputCalendar(request, true, "schDateTo", "schDateTo", schDateTo, "")%></td>
					<th><%=법무법인 %></th>
					<td><%=HtmlUtil.getSelect(request, true, "schbeobryulsamusoCod", "schbeobryulsamusoCod", beobryulsamusoCdStr, schbeobryulsamusoCod, "style=\"width:100%;\" class=\"select\"")%></td>
					<th><%=이름 %></th>
					<td><input type="text" class="text" name="schName" id="schName" value="<%=StringUtil.convertForInput(schName)%>"  style="width:100%;" onkeydown="doSearch(document.form1, true)" /></td>
					<td style="text-align:center;">
						<span class="ui_btn medium icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="doReset(document.form1);"><%=StringUtil.getLocaleWord("B.INIT",siteLocale)%></a></span>
						<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:doSearch(document.form1);"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
					</td> 
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
			<span style="color:red"><%=StringUtil.getLocaleWord("M.외부변호사평가현황기준",siteLocale) %></span>
		</div>
		<div class="right">
	    	<script>
			/*
			 * 엑셀다운로드
			 */
			function doExcelDown(frm){
				frm.action = "/ServletController";
				frm.<%=CommonConstants.ACTION_CODE%>.value = "<%=actionCode%>";
				frm.<%=CommonConstants.MODE_CODE%>.value = "BHST_JSON_EXCEL";
				frm.target = "airBackgroundProcessFrame";
				frm.submit();
			}
			</script>
			<span class="ui_btn medium icon"><span class="save"></span><a href="javascript:void(0)" onclick="doExcelDown(document.form1)"><%=StringUtil.getLocaleWord("B.엑셀저장", siteLocale)%></a></span>		
		</div>
	</div>
	
</form>
	
<!-- 리스트 -->
<table class="basic" id="bhst_table">
 
	<tr>
	    <th style="text-align:center">No.</th>
		<th style="text-align:center"><%=법무법인 %></th>
		<th style="text-align:center"><%=이름 %></th>
		<th style="text-align:center"><%=유형 %></th>
		<th style="text-align:center"><%=평점 %></th>
	</tr>
	<tbody>
<%	 
if(BHST != null && BHST.getRowCount() > 0){
	long rowCnt= 1;
	
	for(int i=0; i<BHST.getRowCount(); i++){
		double pyeongga = Double.valueOf(BHST.getString(i, "PYEONGGA"));
		String comNm	= BHST.getString(i, "COM_NAM");
		String userNm	= BHST.getString(i, "USER_NAM");
		String ma_type	= BHST.getString(i, "MAS_TYPE");
		String sumRow = "<b>"+ StringUtil.getLocaleWord("L.평균",siteLocale)+"</b>";
		if(sumRow.equals(userNm)||sumRow.equals(ma_type)){
%>	
    <tr style='text-align:center'>
		<td><%=rowCnt %></td>
		<td><%=comNm %></td>
		<td><%=userNm %></td>
		<td><%=ma_type %></td>
		<td style="text-align:right;"><b><%=pyeongga %></b></td>
	</tr>
<%      }else{ %>
	<tr style='text-align:center'>
		<td><%=rowCnt %></td>
		<td><%=comNm %></td>
		<td><%=userNm %></td>
		<td><%=ma_type %></td>
		<td style="text-align:right;"><%=pyeongga %></td>
	</tr>
<%	    }
        if(sumRow.equals(BHST.getString(i, "USER_NAME_"+siteLocale))  ){
            rowCnt++;
        }
	}
} else {
%>
	<tr>
		<td colspan="5" class="td1" colspan="12" align="center"><%=검색결과가없습니다%></td>
	</tr>
<%}%>
</tbody>
</table>

</div>
</div>

<script> 
function doReset(frm) {
	if (confirm("<%=StringUtil.getLocaleWord("M.ALERT_RESETSEARCHITEMS",siteLocale)%>")) {
		frm.reset();
		$('#schDateFrom').getDiffDate(1,'year');
		$("#schDateTo").getDiffDate(0,'day');	
		$("#schName").val("");
		$("#schbeobryulsamusoCod").val("");  
	}
}
 

// 오늘,1주일,1달 등등
$(function(){
  $.fn.extend({
    getDiffDate:function(diff,type){
      var to_date = new Date();

      switch(type){
        case 'day':
          to_date.setDate(to_date.getDate()-diff);
          break;

        case 'month':
          to_date.setMonth(to_date.getMonth()-diff);
          break;

        case 'year':
          to_date.setFullYear(to_date.getFullYear()-diff);
          break;
        default:
          return false;
          break;
      }     

      $(this).val(to_date.getFullYear()+'-'+$.fn.setAddZero(to_date.getMonth()+1)+'-'+$.fn.setAddZero(to_date.getDate()));
    },
    setAddZero:function(val){
      var tmp = val.toString();

      if(tmp.length == 1){
        tmp = '0'+tmp;
      }
      return tmp;
    }
  });
});


/**
 * 검색 수행
 */	
function doSearch(frm, isCheckEnter) {
	if (isCheckEnter && event.keyCode != 13) {			
		return;
	}
	
	var stday = frm.schDateFrom.value;  
	var edday = frm.schDateTo.value;  
	 
	if ("" !=stday && "" != edday ){
	    if(stday > edday) {
		    alert ("<%=StringUtil.getLocaleWord("M.ALERT_WRONG",siteLocale,StringUtil.getLocaleWord("L.기간", siteLocale))%>");
		    frm.schDateTo.focus();  
		   return;
		}
	} 
	
	frm.action = "/ServletController";
	frm.<%=CommonConstants.MODE_CODE%>.value = "BHST";
	frm.target = "_self";
	frm.submit();
}
$(function(){
	$("#bhst_table").rowspan2(0);
	$("#bhst_table").rowspan2(1);
	$("#bhst_table").rowspan2(2); 
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

                                                                    && $(this).html() !="<%=StringUtil.getLocaleWord("L.평균",siteLocale) %>" )) { // 값이 '소계' 이면 rowspan 안함.   
                    rowspan = $(that).attr("rowspan") || 1;
                    rowspan = Number(rowspan)+1;
                    
                    $(that).attr("rowspan",rowspan);
                    // do your action for the colspan cell here            
                    $(this).hide();
                    
                    //$(this).remove(); 
                    // do your action for the old cell here
                } else {            
                    that = this;         
                }     
                
                $('#bhst_table').colspan(row); // row 돌때 마다 colspan
                 
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
  
 // alert("col  :  "+rowIdx);
  
    return this.each(function(){
         
        var that;
        $('tr', this).filter(":eq("+rowIdx+")").each(function(row) {
            $(this).find('td').filter(':visible').each(function(col) {
            
            	
                if ($(this).html() == $(that).html()) {
                    colspan = $(that).attr("colSpan") || 1;
                    colspan = Number(colspan)+1;
                     
                    $(that).attr("colSpan",colspan);
                    $(this).hide(); // .remove();  
                    
                	
                 
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

