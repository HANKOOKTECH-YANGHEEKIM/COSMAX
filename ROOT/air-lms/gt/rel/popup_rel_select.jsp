<%--
  - Author : 강세원
  - Date : 2016.06.16
  - 
  - @(#)
  - Description : 관련 계약/자문/소송/분쟁 선택 팝업
  --%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.emfrontier.air.lms.config.LmsConstants"%>
<%@page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%@page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@page import="com.emfrontier.air.common.bean.BeanResultMap"%>
<%@page import="com.emfrontier.air.common.config.CommonConstants" %>    
<%@page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@page import="com.emfrontier.air.common.util.HtmlUtil" %>
<%@page import="com.emfrontier.air.common.util.StringUtil" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
String siteLocale = CommonProperties.getSystemDefaultLocale();

if (loginUser != null) {
	siteLocale = loginUser.getSiteLocale();
}
Map<String, Object> insMap = new HashMap<String, Object>();
//-- 검색값 셋팅
BeanResultMap requestMap     = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
String pageNo               = requestMap.getString(CommonConstants.PAGE_NO);
String pageRowSize          = requestMap.getString(CommonConstants.PAGE_ROWSIZE);
String pageOrderByField     = requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
String pageOrderByMethod    = requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);
String callbackFunction     = requestMap.getString("CALLBACKFUNCTION");
String sol_mas_uid		    = requestMap.getString("SOL_MAS_UID");
String rel_sol_mas		    = requestMap.getString("REL_SOL_MAS");
String gubun				= requestMap.getString("GUBUN");
String add_save				= requestMap.getString("ADD_SAVE");
String TEP_CODE				= requestMap.getString("TEP_CODE");	
String frameId				= requestMap.getString("FRAMEID");

//-- 결과값 셋팅
BeanResultMap responseMap             = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);  

//String GYEYAG_YUHYEONG_CODESTR = StringUtil.getCodestrFromSQLResults(responseMap.getResult("GYEYAG_YUHYEONG_CODE_LIST"), "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));
String SYS_GBN_LMSSTR 		= "";
String page_tit = "";
boolean isBeobmuTeamUser = LmsUtil.isBeobmuTeamUser(loginUser);

String rdoAll = StringUtil.getLocaleWord("L.전체",siteLocale);
String rdoGy = StringUtil.getLocaleWord("L.계약",siteLocale);
String rdoGyOld = StringUtil.getLocaleWord("L.구계약",siteLocale);
String rdoJm = StringUtil.getLocaleWord("L.자문",siteLocale);
String rdoJmOld = StringUtil.getLocaleWord("L.구자문",siteLocale);
String rdoSs = StringUtil.getLocaleWord("L.소송",siteLocale);
String rdoSsOld = StringUtil.getLocaleWord("L.구소송분쟁",siteLocale);

if(isBeobmuTeamUser){
	if("IJ".equals(gubun)){
		SYS_GBN_LMSSTR = "|--" + rdoAll + "--^GY|" + rdoGy + "^JM|" + rdoJm;
		
	}else if("PJ_TEP".equals(gubun)){
		if("LMS_TEP_PJ_GY".equals(TEP_CODE)) {
			SYS_GBN_LMSSTR = "|--" + rdoAll + "--^GY|" + rdoGy + "^GY_OLD|" + rdoGyOld;
		}else if("LMS_TEP_PJ_JM".equals(TEP_CODE)) {
			SYS_GBN_LMSSTR = "|--" + rdoAll + "--^JM|" + rdoJm + "^JM_OLD|" + rdoJmOld;
		}else if("LMS_TEP_PJ_SS".equals(TEP_CODE)) {
			SYS_GBN_LMSSTR = "|--" + rdoAll + "--^SS|" + rdoSs + "^SS_OLD|" + rdoSsOld;
		}
		
	}else{
		SYS_GBN_LMSSTR = "|--" + rdoAll + "--^GY|" + rdoGy + "^JM|" + rdoJm + "^SS|" + rdoSs + "^GY_OLD|" + rdoGyOld + "^JM_OLD|" + rdoJmOld;
	}
	
	page_tit = StringUtil.getLocaleWord("L.관련건검색",siteLocale);
}else{
	SYS_GBN_LMSSTR = "|--" + rdoAll + "--^GY|" + rdoGy + "^JM|" + rdoJm;
	page_tit = StringUtil.getLocaleWord("L.관련건검색",siteLocale);
}

String actionCode        = responseMap.getString(CommonConstants.ACTION_CODE);
String modeCode         = responseMap.getString(CommonConstants.MODE_CODE);
String contentName     = (String)StringUtil.convertNull(request.getAttribute(CommonConstants.CONTENT_NAME));
String multiYn				= "";

String jsonDataMasUrl = "/ServletController"
 + "?AIR_ACTION="+actionCode
 + "&AIR_MODE=MAS_JSON_LIST"
 + "&gubun=" + gubun
 + "&sol_mas_uid="+sol_mas_uid
+ "&TEP_CODE="+TEP_CODE;

String jsonDataRelUrl = "/ServletController"
        + "?AIR_ACTION="+actionCode  
        + "&AIR_MODE=REL_JSON_LIST"
        + "&sol_mas_uid="+sol_mas_uid
        + "&gubun=" + gubun
        + "&TEP_CODE="+TEP_CODE;
%>
<!-- // Content // -->
<form id="form1" name="form1" method="post">
<input type="hidden" name="sol_mas_uid" value="<%=StringUtil.convertForInput(sol_mas_uid)%>" />
<input type="hidden" name="TEP_CODE" value="<%=TEP_CODE%>" />
<input type="hidden" name="DOC_SAVE_MODE" value="WRITE" />

    <table class="box">
    <caption><%=page_tit %></caption>
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
	                    <col style="width:10%" />
	                    <col style="width:10%" />
	                    <col style="width:auto" />
						<col style="width:140px;" />
	                </colgroup>
	                <tr>
	                    <td>
	                        <%=HtmlUtil.getSelect(request, true, "sch_gubun", "sch_gubun", SYS_GBN_LMSSTR, "", "onchange=\"javascript:gy_search(document.form1, true);\" data-type=\"search\" style='width:100%;'")%>
	                    </td>
	                    <th><%=StringUtil.getLocaleWord("L.제목_사건명",siteLocale)%></th>
	                    <td><input type="text" name="title" id="title" value="" onkeydown="gy_search(document.form1, true)" data-type="search" maxlength="50" class="text width_max" /></td>
	                    <td class="verticalContainer">
                  			<span class="ui_btn medium icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="doReset(document.form1);"><%=StringUtil.getLocaleWord("B.INIT", siteLocale)%></a></span>
	                    	<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="gy_search(document.form1);" ><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
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
    <br>
    <table id="lmsList" 
            data-options="
                singleSelect:true,    
		        striped:true,         
		        fitColumns:true,      
		        rownumbers:true,      
		        multiSort:true,       
		        pagination:true,      
		        pagePosition:'bottom',
		        method:'post', 
		        selectOnCheck:true, 
		        checkOnSelect:true,
		        url:'<%=jsonDataMasUrl%>'
            " 
            style="width:auto;height:auto"> 
    <thead>
        <tr>
            <th data-options="field:'SOL_MAS_UID',width:0,hidden:true"></th>                 
            <th data-options="field:'GUBUN',width:0,hidden:true"></th>                 
<!--             <th data-options="field:'CK',halign:'center',align:'center',checkbox:true" width="5%"></th> -->
            <th data-options="field:'GUBUN_NAME',width:80,halign:'center',align:'center'" width="7%"><%=StringUtil.getLocaleWord("L.구분",siteLocale)%></th>
            <th data-options="field:'TITLE_NO',width:120,halign:'center',align:'center'" width="10%"><%=StringUtil.getLocaleWord("L.관리번호",siteLocale)%></th>
            <th data-options="field:'TITLE',width:460,halign:'center',align:'left'"><%=StringUtil.getLocaleWord("L.제목_사건명",siteLocale)%></th>
            <th data-options="field:'REG_DTE',width:100,halign:'center',align:'center'"><%=StringUtil.getLocaleWord("L.의뢰일_작성일",siteLocale)%></th>
            <th data-options="field:'DAMDANG_NAM',width:120,halign:'center',align:'center'"><%=StringUtil.getLocaleWord("L.담당자",siteLocale)%></th>
            <th data-options="field:'STU_NAM',width:140,halign:'center',align:'center'"><%=StringUtil.getLocaleWord("L.진행상태",siteLocale)%></th>
<!--             <th data-options="field:'BUTTON',width:0,hidden:true"></th> -->
            
        </tr>
    </thead>
    </table>

    <table class="basic">
        <caption><%=StringUtil.getLocaleWord("L.선택된_현황",siteLocale)%></caption>
        <tr>
            <td></td>
        </tr>
    </table> 
    <table id="gyeyagSelStat"
            data-options="
	            singleSelect:true,    
	            striped:true,    
	            fitColumns:true,
	            rownumbers:true,
	            multiSort:true,
	            pagination:false,      
	            method:'post',        
	            selectOnCheck:true,   
	            checkOnSelect:true,
	            url:'<%=jsonDataRelUrl%>'
            " 
            style="width:auto;height:auto"> 
    <thead>
        <tr>
            <th data-options="field:'SOL_MAS_UID',hidden:true" width="0%"></th>
            <th data-options="field:'GUBUN',hidden:true" width="0%"></th>                 
            <th data-options="field:'GUBUN_NAME',halign:'center',align:'center'" width="7%"><%=StringUtil.getLocaleWord("L.구분",siteLocale)%></th>
            <th data-options="field:'TITLE_NO',halign:'center',align:'center'" width="10%"><%=StringUtil.getLocaleWord("L.관리번호",siteLocale)%></th>
            <th data-options="field:'TITLE',halign:'center',align:'left'" width="45%"><%=StringUtil.getLocaleWord("L.제목_사건명",siteLocale)%></th>
            <th data-options="field:'REG_DTE',halign:'center',align:'center'" width="10%"><%=StringUtil.getLocaleWord("L.의뢰일_작성일",siteLocale)%></th>
            <th data-options="field:'DAMDANG_NAM',halign:'center',align:'center'" width="8%"><%=StringUtil.getLocaleWord("L.담당자",siteLocale)%></th>
            <th data-options="field:'STU_NAM',halign:'center',align:'center'" width="17%"><%=StringUtil.getLocaleWord("L.진행상태",siteLocale)%></th>
            <th data-options="field:'BUTTON',halign:'center',align:'center'" width="5%"></th>
        </tr>
    </thead>
    </table>
    <div class="buttonlist">
         <div class="left">
         </div>
         <div class="right">
         	<span class="ui_btn medium icon"><span class="confirm"></span><a href="javascript:void(0)" onClick="setGWGY()"><%=StringUtil.getLocaleWord("B.CONFIRM",siteLocale)%></a></span> 
         </div>                      
    </div>
</form>
<script type="text/javascript">
var doReset = function(frm){
	frm.reset();
};

function gy_search(frm, isCheckEnter){
 	if (isCheckEnter && event.keyCode != 13) {         
        return;
    }
 <%-- 	<%=gubun %><%=multiYn %> --%>
 	
    $("#lmsList").datagrid('load',airCommon.getSearchQueryParams());
}

/**
 * 관련계약 반영
 */
function setGWGY(){
	var selData = $('#gyeyagSelStat').datagrid('getData');
	<%
	if("Y".equals(add_save)){		
	%>
	var TEP_CODE = "<%=TEP_CODE%>";
	var frameId  = "<%=frameId%>";

	var SOL_MAS_UID = "<%=sol_mas_uid%>";
	// save data
	$.ajax({
	       url:'/ServletController?<%=CommonConstants.ACTION_CODE%>=LMS_GT_TEP_REL&<%=CommonConstants.MODE_CODE%>=SAVE_PROC',
	       type : 'POST',
	       async : true,
	       cache : false,
	       data : {selData:JSON.stringify(selData),TEP_CODE:TEP_CODE,DOC_SAVE_MODE:"WRITE",SOL_MAS_UID:SOL_MAS_UID},
	       dataType : 'json',
	       error : function(data){
	           // NONE
	           alert("<%=StringUtil.getScriptMessage("M.에러처리",siteLocale)%>");
	           return false;
	       },
	       success : function(data){
	           alert("<%=StringUtil.getScriptMessage("M.처리_되었습니다",siteLocale)%>");
	           self.close();
	           
	           opener.parent.tep_frameResize(frameId);
               opener.thisResize(); 
	       } 
	   });

	<%
	}else{
	%> 
	<%
	if(StringUtils.isNotBlank(callbackFunction)){
	%>
		opener.<%=callbackFunction%>(JSON.stringify(selData.rows));
		self.close();
	<%
	}else{
	%>
		try{
			opener.setRelContract(JSON.stringify(selData.rows));
		}catch(e){
			alert("<%=StringUtil.getScriptMessage("M.에러처리",siteLocale)%>");
		}
	<%
	}
	%>
 	<%
	}
	%> 
}

$(document).ready(function () {
    $("#lmsList").datagrid({
    	onBeforeLoad:function() { airCommon.showBackDrop(); },
      	onLoadSuccess:function() {
			airCommon.hideBackDrop(), airCommon.gridResize();
		},
        onCheck: function(index, row){
            var selData = $('#gyeyagSelStat').datagrid('getData');
            var existFlag = false;
            var selDataLength = 0;
            
            <%if("N".equals(multiYn)){%>
			if(selData.rows.length == 1){
				selDataLength = 0;
			}else{
				selDataLength = selData.rows.length;
			}
            
            <%}else{%>
            selDataLength = selData.rows.length;
            <%}%>
            
            for(var i = 0, iLength = selData.rows.length; i < iLength; i+=1){
            	
                if(row.SOL_MAS_UID == selData.rows[i].SOL_MAS_UID){
                    existFlag = true;
                    break;
                }
            }// end of for
            
            if(existFlag){
                alert("<%=StringUtil.getScriptMessage("M.이미선택됨",siteLocale)%>");
            }else{
            	<%if("N".equals(multiYn)){%>
            	if(selData.rows.length == 0){
            		$('#gyeyagSelStat').datagrid('appendRow',{
                        SOL_MAS_UID : row.SOL_MAS_UID,
                        GUBUN : row.GUBUN,
                        GUBUN_NAME : row.GUBUN_NAME,
                        TITLE_NO : row.TITLE_NO,
                        TITLE : row.TITLE,
                        REG_DTE : row.REG_DTE,
                        DAMDANG_NAM : row.DAMDANG_NAM,
                        STU_NAM : row.STU_NAM,
                        BUTTON : "<span class=\"ui_btn small icon\"><span class=\"delete\"></span><a href=\"javascript:void(0)\"></a></span>"
                    });
            	}else{
            		alert("<%=StringUtil.getScriptMessage("M.하나만선택가능",siteLocale)%>");
            	}
            	
            	<%}else{%>
            	$('#gyeyagSelStat').datagrid('appendRow',{
                    SOL_MAS_UID : row.SOL_MAS_UID,
                    GUBUN : row.GUBUN,
                    GUBUN_NAME : row.GUBUN_NAME,
                    TITLE_NO : row.TITLE_NO,
                    TITLE : row.TITLE,
                    REG_DTE : row.REG_DTE,
                    DAMDANG_NAM : row.DAMDANG_NAM,
                    STU_NAM : row.STU_NAM,
                    BUTTON : "<span class=\"ui_btn small icon\"><span class=\"delete\"></span><a href=\"javascript:void(0)\"></a></span>"
                });
            	<%}%>
            }
        }
        
    });
    
     $("#gyeyagSelStat").datagrid({
    	 onBeforeLoad:function() { airCommon.showBackDrop(); },
       	onLoadSuccess:function() {
 			airCommon.hideBackDrop(), airCommon.gridResize();
 		},
    	 onClickCell: function(index,field ,row){
    		 if("BUTTON" == field){
           		 $(this).datagrid('deleteRow',index);
    		 }
        }
    }); 
});
</script>