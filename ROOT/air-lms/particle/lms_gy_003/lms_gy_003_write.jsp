<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%
	SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale = loginUser.getSiteLocale();
	
	String mng_pati_uid         = StringUtil.convertNull(request.getParameter("AIR_PARTICLE"));
	String doc_mas_mode_code = StringUtil.convertNull(request.getParameter("doc_mas_mode_code"));
	String doc_mas_uid			= StringUtil.convertNull(request.getParameter("doc_mas_uid"));
	String sol_mas_uid			= StringUtil.convertNull(request.getParameter("sol_mas_uid"));
	String new_doc_mas_uid		= StringUtil.convertNull(request.getParameter("new_doc_mas_uid"));
	
	BeanResultMap resultMap = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	SQLResults solMasInfo= resultMap.getResult("SOL_MAS_INFO");
	String munseo_seosig_no = resultMap.getString("MUNSEO_SEOSIG_NO");
	BeanResultMap jsonMap = (BeanResultMap)request.getAttribute(CommonConstants._JSON_DATA);
	if(jsonMap == null)jsonMap = new BeanResultMap();
	
	/* Code Start	
	String sampleField      = "";	
	*/
	String lms_pati_gy_003_uid 	= jsonMap.getString("LMS_PATI_GY_003_UID");
	
	String eobmu_gbn_code = "";
	
	if(solMasInfo != null && solMasInfo.getRowCount() > 0){
		eobmu_gbn_code = solMasInfo.getString(0, "EOBMU_GBN_CODE");
	}
	
	if("".equals(lms_pati_gy_003_uid)){
		lms_pati_gy_003_uid = StringUtil.getRandomUUID();
	}
	
	String new_lms_pati_gy_003_uid   = StringUtil.getRandomUUID();
	
	// 갱신일 경우 UID 생성
    if("UPDATE_FORM_INCLUDE".equals(doc_mas_mode_code) || 
            "UPDATE_FORM_REV_EDIT_INCLUDE".equals(doc_mas_mode_code)){
    	lms_pati_gy_003_uid = new_lms_pati_gy_003_uid;
    }
	
    String hoesa_cd = "";
	String group_cd = "";
	String group_name = "";
	String group_name_ko= "";
	String group_name_en = "";
	
	String att_master_doc_id 			= doc_mas_uid;
	String att_default_master_doc_Ids 	= jsonMap.getString("DOC_MAS_UID");
    
   String chamjojaCod = "";
   String chamjojaNam = "";
	
	//-- 시스템 코드에서 값 가저오기 
	//	String SampleCodStr = StringUtil.getCodestrFromSQLResults(SampleCodeList, "CODE_ID,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));
	String jsonHistUrl = "/ServletController"
        + "?AIR_ACTION=LMS_MAIN"  
        + "&AIR_MODE=JSON_BAEDANG_HIST"
        + "&GUBUN="+eobmu_gbn_code+"&DOC_MAS_UID="+doc_mas_uid;
	
	String jsonDataUrl = "/ServletController"
        + "?AIR_ACTION=LMS_MAIN"
        + "&AIR_MODE=JSON_BAEDANG_STAT"
        + "&GUBUN="+eobmu_gbn_code;
	
	String jsonDetailUrl = "/ServletController"
	        + "?AIR_ACTION=LMS_MAIN"  
	        + "&AIR_MODE=JSON_DAMDANG_STAT"
	        + "&DAMDANG_ID=";
%>
<script type="text/javascript">
    <%//Particle Data Field Check%>
    var frm = document.saveForm<%=sol_mas_uid%>;
    
	function <%="Parti"+mng_pati_uid%>_dataCheck(){
		
		if ("" == frm.lms_pati_damdang_id.value ) {
			alert ("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getLocaleWord("L.담당자", siteLocale))%>");
			frm.lms_pati_damdang_id.focus();
			return false;
		}
		
		
		return true;
	}
</script>

<!-- 날짜입력 예시 -->
<!--input type="text" name="sampleField" id="sampleField" value="< %=StringUtil.convertForInput(sampleField) % >" class="date" onfocus="this.select()" onblur="airCommon.validateDateObject(this);"  /> <input type="button" value=" " onclick="javascript:airCommon.openInputCalendar('sampleField');" class="btn_calendar" /-->

<!-- 텍스트 필드 입력 예시 -->
<!--input type="text" class="text width_max" name="sampleField" id="sampleField" size="2" value="< %=sampleField % >" /-->

<!-- 텍스트(숫자전용) 필드 입력 예시 -->
<!--input type="text" name="sampleField" id="sampleField" size="2" value="< %=sampleField % >" onblur="airCommon.validateNumber(this, this.value)" /-->

<!-- 텍스트 영역 입력 예시 -->
<!--textarea class="memo width_max" name="sampleField" id="content" onkeyup="airCommon.validateMaxLength(this, 2000)">< %=sampleField % ></textarea-->

<!-- 시스템 코드 항목으로 라디오 만들기 -->
<!--%=HtmlUtil.getSelect(request, true, "sample_sys_cod_id", "sample_sys_cod_id", SampleCodStr, sample_sys_cod_id, "") %-->

<!-- 파일첨부하기 -->
<!-- ips_cw_004_write.jsp 참조 -->

<!-- 필수값 * 마크 추가 -->
<!-- Input type="button" class="required" tabindex="-1"-->

<!-- 여기서부터 코딩하세요. -->
<input type="hidden" name="lms_pati_gy_003_uid" value="<%=lms_pati_gy_003_uid%>" />
<div id="div_PTC-LMS-GY-003">
    <p>
	<table class="basic">
		<caption><%=StringUtil.getLocaleWord("L.담당자지정",siteLocale)%></caption>
		<colgroup></colgroup>
		<tr>
	        <th class="th4"><%=StringUtil.getLocaleWord("L.참조부서_열람가능",siteLocale)%></th>
	        <td class="td4">
	            <script type="text/javascript"> 
	            function searchChamjobuseo() {
	            	var groupCodestr = "";
	            	var param ={};
	            	
	            	param["groupTypeCodes"]= "IG";
	            	param["groupCodestr"]= groupCodestr;
	            	param["initFunction"]= "initChamjobuseo";
	            	
	            	airCommon.popupGroupSelects("changeChamjobuseo", param);
	            }
	            var initChamjobuseo = function(){
	            	if($("#lms_pati_chamjobuseo_cod").val() != "" ){ 
	    	        	var codes = $("#lms_pati_chamjobuseo_cod").val().split(",");
	    	        	var groups_ko = $("#lms_pati_chamjobuseo_nam_ko").val().split("\n");
	    	        	var groups_en = $("#lms_pati_chamjobuseo_nam_en").val().split("\n");
	    	        	var arrJson = [];
	    	        	var i = 0;
	    	        	for(i=0; i< codes.length; i++){
	    	        		arrJson.push({
	    		        			 UUID: ""
	    		        			 ,CODE: codes[i]
	    		        			 ,PARENT_CODE: ""
	    		        			 ,NAME_KO: groups_ko[i]
	    		        			 ,NAME_EN: groups_en[i]
	    		        			 ,PARENT_NAME_KO: ""
	    		        			 ,PARENT_NAME_EN: ""
	    		        			 ,NAME_PATH_KO: ""
	    		        			 ,NAME_PATH_EN: ""
	    		        	});
	    	        	}
	    	        	return JSON.stringify(arrJson);
	            	}else{
		           		return "";
	            	}
	            }
	            function changeChamjobuseo(data) {
	            	var jsonData = JSON.parse(data);
	            	console.log(data);
	            	var init_code = "";
	            	var init_name = "";
	            	var init_name_ko = "";
	            	var init_name_en = "";
	            	for(var i = 0; i< jsonData.length; i++){
	            		if(i > 0){
	            			init_code += ",";
	            			init_name += "\n";
	            			init_name_ko += "\n";
	            			init_name_en += "\n";
	            		}
	            		init_code += jsonData[i].CODE;
	           			init_name += jsonData[i].NAME_KO;
	           			init_name_ko += jsonData[i].NAME_KO;
	           			init_name_en += jsonData[i].NAME_EN;
	            	}
	            	setChamjobuseo(true, init_code, init_name, init_name_ko, init_name_en);
	            }
	    		/**
	    		 * 관련부서 초기화
	    		 */
	    		function setChamjobuseo(isForceInit, code, name, name_ko, name_en) {
	    			code = (code == undefined ? "" : code);
	    			name = (name == undefined ? "" : name);
	    			name_ko = (name_ko == undefined ? "" : name_ko);
	    			name_en = (name_en == undefined ? "" : name_en);
	    			
	    			if (!isForceInit && !confirm("<%=StringUtil.getScriptMessage("M.관련부서정보를초기화하시겠습니까",siteLocale)%>")) {
	    				return false;
	    			}
	    			document.getElementById("lms_pati_chamjobuseo_cod").value = code;
	    			document.getElementById("lms_pati_chamjobuseo_nam").value = name;
	    			document.getElementById("lms_pati_chamjobuseo_nam_ko").value = name_ko;
	    			document.getElementById("lms_pati_chamjobuseo_nam_en").value = name_en;
	    			$("#lms_pati_chamjobuseo_nam").val().replace("\n", '<br>');
	    			$("#lms_pati_chamjobuseo_nam_ko").val().replace("\n", '<br>');
	    			$("#lms_pati_chamjobuseo_nam_en").val().replace("\n", '<br>');
	    		}
	            </script>
	            <input type="hidden" name="lms_pati_chamjobuseo_cod" id="lms_pati_chamjobuseo_cod" value="<%=StringUtil.convertForInput(jsonMap.getDefStr("LMS_PATI_CHAMJOBUSEO_COD",group_cd)) %>"  />            
	            <input type="hidden" name="lms_pati_chamjobuseo_nam_ko" id="lms_pati_chamjobuseo_nam_ko" value="<%=StringUtil.convertForInput(jsonMap.getDefStr("LMS_PATI_CHAMJOBUSEO_NAM_KO",group_name_ko)) %>"  />
	            <input type="hidden" name="lms_pati_chamjobuseo_nam_en" id="lms_pati_chamjobuseo_nam_en" value="<%=StringUtil.convertForInput(jsonMap.getDefStr("LMS_PATI_CHAMJOBUSEO_NAM_EN",group_name_en)) %>"  />
	    		<span style="float:left;">
	                <span class="ui_btn small icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="setChamjobuseo(false)"><%=StringUtil.getLocaleWord("B.INIT",siteLocale)%></a></span>
					<span class="ui_btn small icon"><span class="search"></span><a href="javascript:void(0)" onclick="searchChamjobuseo()"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
				</span>	
	    		<textarea name="lms_pati_chamjobuseo_nam" id="lms_pati_chamjobuseo_nam" readonly="readonly" class="width_max" rows="5"><%=StringUtil.convertForInput(jsonMap.getDefStr("LMS_PATI_CHAMJOBUSEO_NAM_"+siteLocale,group_name)) %></textarea>
	        </td>
	        <th class="th4"><%=StringUtil.getLocaleWord("L.참조자_열람가능",siteLocale)%></th>
	        <td class="td4">
	           <script type="text/javascript"> 
	            function searchChamjoja() {
	            	var defaultUser = $("#lms_pati_chamjoja_cod").val();
					var param ={};
	            	
	            	param["groupTypeCodes"]= "IG";
	            	param["defaultUser"]= defaultUser;
	            	param["userType"]= "chamjo";
	            	
	            	airCommon.popupUserSelect("changeChamjoja", param);
	            }
	            
	            function changeChamjoja(data) {
	            	
	            	var jsonData = JSON.parse(data);
	            	var init_code = "";
	            	var init_name = "";
	            	var init_name_ko = "";
	            	var init_name_en = "";
	            	
	            	for(var i = 0; i< jsonData.length; i++){
	            		if(i > 0){
	            			init_code += ",";
	            			init_name += "\n";
	            			init_name_ko += "\n";
	            			init_name_en += "\n";
	            		}
	            		init_code += jsonData[i].LOGIN_ID;
	           			init_name += jsonData[i].GROUP_NAME_KO+" "+jsonData[i].NAME_KO +" "+jsonData[i].POSITION_NAME_KO;
	           			init_name_ko += jsonData[i].GROUP_NAME_KO +" "+jsonData[i].NAME_KO;
	           			init_name_en += jsonData[i].GROUP_NAME_EN +" "+jsonData[i].NAME_EN; 
	            	}
	            	initChamjoja(true, init_code, init_name, init_name_ko, init_name_en);
	            	
	            }
	            
	            function initChamjoja(isForceInit, code, name, name_ko, name_en) {
	            	code = (code == undefined ? "" : code);
	            	name = (name == undefined ? "" : name);
	            	name_ko = (name_ko == undefined ? "" : name_ko);
	            	name_en = (name_en == undefined ? "" : name_en);
	            	
	            	if (!isForceInit && !confirm("<%=StringUtil.getScriptMessage("M.참조자정보를초기화하시겠습니까",siteLocale)%>")) {
	            		return false;
	            	}
	            		
	            	document.getElementById("lms_pati_chamjoja_cod").value = code;
	            	document.getElementById("lms_pati_chamjoja_nam").value = name;
	            	document.getElementById("lms_pati_chamjoja_nam_ko").value = name_ko;
	            	document.getElementById("lms_pati_chamjoja_nam_en").value = name_en;
	            	 
	            	$("#lms_pati_chamjoja_nam").val().replace("\n", '<br>');
	            	$("#lms_pati_chamjoja_nam_ko").val().replace("\n", '<br>');
	            	$("#lms_pati_chamjoja_nam_en").val().replace("\n", '<br>');
	            }                        
	            </script>
	            <input type="hidden" id="lms_pati_chamjoja_cod" name="lms_pati_chamjoja_cod" value="<%=StringUtil.convertForInput(jsonMap.getDefStr("LMS_PATI_CHAMJOJA_COD",chamjojaCod)) %>">
	            <input type="hidden" id="lms_pati_chamjoja_nam_ko" name="lms_pati_chamjoja_nam_ko" value="<%=StringUtil.convertForInput(jsonMap.getString("LMS_PATI_CHAMJOJA_NAM_KO")) %>">
	            <input type="hidden" id="lms_pati_chamjoja_nam_en" name="lms_pati_chamjoja_nam_en" value="<%=StringUtil.convertForInput(jsonMap.getString("LMS_PATI_CHAMJOJA_NAM_EN")) %>">
	            <span style="float:left;"> 
				    <span class="ui_btn small icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="initChamjoja(false)"><%=StringUtil.getLocaleWord("B.INIT",siteLocale)%></a></span>
				    <span class="ui_btn small icon"><span class="search"></span><a href="javascript:void(0)" onclick="searchChamjoja()"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
	             </span>	
	            <textarea name="lms_pati_chamjoja_nam" id="lms_pati_chamjoja_nam" readonly="readonly"  class="width_max"  rows="5"><%=StringUtil.convertForInput(jsonMap.getDefStr("LMS_PATI_CHAMJOJA_NAM",chamjojaNam)) %></textarea>
	<%--             <br/><span style="color: red"><%=StringUtil.getLocaleWord("M.참조자_선택_알림",siteLocale) %></span> --%>
	        </td>
	    </tr>
	   </table>
	   <table class="basic">
		<tr>
			<th style="text-align:center;width:5%;"><%=StringUtil.getLocaleWord("L.선택",siteLocale)%></th>
			<th style="text-align:center;width:18%;"><%=StringUtil.getLocaleWord("L.이름",siteLocale)%></th>
			<th style="text-align:center;width:12.1%;"><%=StringUtil.getLocaleWord("L.계약_진행",siteLocale)%></th>
			<th style="text-align:center;width:12.1%;"><%=StringUtil.getLocaleWord("L.계약_완료",siteLocale)%></th>
			<th style="text-align:center;width:12.1%;"><%=StringUtil.getLocaleWord("L.자문_진행",siteLocale)%></th>
			<th style="text-align:center;width:12.1%;"><%=StringUtil.getLocaleWord("L.자문_완료",siteLocale)%></th>
			<th style="text-align:center;width:12.1%;"><%=StringUtil.getLocaleWord("L.소송_진행",siteLocale)%></th>
			<th style="text-align:center;width:12.1%;"><%=StringUtil.getLocaleWord("L.소송_완료",siteLocale)%></th>
		</tr>
		<tbody id="damdangBody"></tbody>
	</table>
	<p/>
 
	<table class="basic">
        <tr>
            <th class="th2">
                <%=StringUtil.getLocaleWord("L.담당자",siteLocale)%>
            </th>
            <td class="td2">
                <span id="view_damdnag_nam"><%=jsonMap.getString("LMS_PATI_DAMDANG_NAM_"+siteLocale) %></span>
                <input type="hidden" id="lms_pati_damdang_id" name="lms_pati_damdang_id" value="<%=jsonMap.getString("LMS_PATI_DAMDANG_ID") %>">
                <input type="hidden" id="lms_pati_damdang_view" name="lms_pati_damdang_view" value="<%=jsonMap.getString("LMS_PATI_DAMDANG_VIEW") %>">
                <input type="hidden" id="lms_pati_damdang_nam_ko" name="lms_pati_damdang_nam_ko" value="<%=jsonMap.getString("LMS_PATI_DAMDANG_NAM_KO") %>">
                <input type="hidden" id="lms_pati_damdang_nam_en" name="lms_pati_damdang_nam_en" value="<%=jsonMap.getString("LMS_PATI_DAMDANG_NAM_EN") %>">
            </td>
        </tr>
        <%-- 
        <tr style="display: none;">
            <th class="th2">
                <%=StringUtil.getLocaleWord("L.담당자옵션",siteLocale)%>
            </th>
            <td class="th2">
                <%=HtmlUtil.getInputCheckbox(request,  true, "lms_pati_damdang_only", "Y|" + StringUtil.getLocaleWord("R.담당자만_공개",siteLocale)
                                              ,jsonMap.getString("LMS_PATI_DAMDANG_ONLY"), "", "style=\"color:blue;\"")%>
	            <%=HtmlUtil.getInputCheckbox(request,  true, "lms_pati_damdang_jeongyeol_yn", "Y|" + StringUtil.getLocaleWord("R.담당자_전결",siteLocale)
                                              ,jsonMap.getString("LMS_PATI_DAMDANG_JEONGYEOL_YN"), "", "style=\"color:blue;\"")%>
            </td>
        </tr>
         --%>
        <tr>
            <th class="th2">
                <%=StringUtil.getLocaleWord("L.담당자_지정_의견",siteLocale)%>
            </th>
            <td class="td2">
            	<textarea rows="5" class="text width_max" name="lms_pati_memo" id="lms_pati_memo"><%=jsonMap.getStringEditor("LMS_PATI_MEMO") %></textarea>
            </td>
        </tr>
    </table>

    <p>
    </p>
    <script id="damdangListTmpl" type="text/html">
    <tr id="\${UUID}">
		<td style="text-align:center;"><input type='radio' value='0' name="chkRadio" onclick="javascript:setDamdang('\${LOGIN_ID}','\${NAME_KO}','\${GROUP_NAME_KO}','\${POSITION_NAME_KO}')"></td>
  		<td style="text-align:left;">\${GROUP_NAME_KO} \${NAME_KO} \${POSITION_NAME_KO}</td>
		<td style="text-align:right;"><a href="javascript:void(0);" style="color:red !important;font-weight:bold;" onclick="javascript:setAjaxList('\${UUID}','\${LOGIN_ID}','GY','JH')">\${GY_JH_CNT}</a></td>
		<td style="text-align:right;"><a href="javascript:void(0);" style="color:red !important;font-weight:bold;" onclick="javascript:setAjaxList('\${UUID}','\${LOGIN_ID}','GY','WR')">\${GY_WR_CNT}</a></td>
		<td style="text-align:right;"><a href="javascript:void(0);" style="color:red !important;font-weight:bold;" onclick="javascript:setAjaxList('\${UUID}','\${LOGIN_ID}','JM','JH')">\${JM_JH_CNT}</a></td>
		<td style="text-align:right;"><a href="javascript:void(0);" style="color:red !important;font-weight:bold;" onclick="javascript:setAjaxList('\${UUID}','\${LOGIN_ID}','JM','WR')">\${JM_WR_CNT}</a></td>
		<td style="text-align:right;"><a href="javascript:void(0);" style="color:red !important;font-weight:bold;" onclick="javascript:setAjaxList('\${UUID}','\${LOGIN_ID}','SS','JH')">\${SS_JH_CNT}</a></td>
		<td style="text-align:right;"><a href="javascript:void(0);" style="color:red !important;font-weight:bold;" onclick="javascript:setAjaxList('\${UUID}','\${LOGIN_ID}','SS','WR')">\${SS_WR_CNT}</a></td>
	</tr>
	<tr id="tr-\${UUID}" data-meaning="detailTr" style="display:none;">
		<td></td>
		<th style="text-align:center"><%=StringUtil.getLocaleWord("L.상세",siteLocale)%></th>
		<td colspan="6">
			<table class="basic" >
				<colgroup>
					<col style="width:15%">
					<col style="width:13%">
					<col style="width:75%">
				</colgroup>	
				<tr>
					<th style="text-align:center"><%=StringUtil.getLocaleWord("L.상태",siteLocale)%></th>
					<th style="text-align:center">요청일<%-- <%=StringUtil.getLocaleWord("L.접수일",siteLocale)%> --%></th>
					<th style="text-align:center"><%=StringUtil.getLocaleWord("L.담당건_명칭",siteLocale)%></th>
				</tr>
				<tbody id="detail-\${UUID}"></tbody>
			</table>
		</td>
	</tr>
	</script> 
    <script id="detailView" type="text/html">
		<tr>
			<td style="text-align:center;">\${STU_NAM}</td>
			<td style="text-align:center;">\${JIJEONG_DTE}</td>
			<td style="text-align:left;">\${JAGUP_NAME}</td>
		</tr>
	</script> 
	<script type="text/javascript">
	var setDamdang = function( id, nam_ko, group_name_ko, position_name_ko ){
		$("#view_damdnag_nam").html(group_name_ko + " "+ nam_ko+ " "+ position_name_ko);
        $("#lms_pati_damdang_id").val(id);
        $("#lms_pati_damdang_view").val(group_name_ko + " "+ nam_ko+ " "+ position_name_ko);
        $("#lms_pati_damdang_nam_ko").val(nam_ko);
//         $("#lms_pati_damdang_nam_en").val(nam_en);
	};
	
	$(document).ready(function () {
		$.ajax({
			url: "<%=jsonDataUrl%>"
			, type: "POST"
			, async: true
			, cache: false
		}).done(function(data){
			$("#damdangListTmpl").tmpl(data).appendTo($("#damdangBody"));
		});
	});
	
	var setAjaxList = function(uuid, id, gubun, stat){
		var url = "<%=jsonDetailUrl%>"+id;
		url += "&GUBUN="+gubun;
		url += "&STAT="+stat;
		$.ajax({
			url: url
			, type: "POST"
			, async: true
			, cache: false
			, data: $(frm).serialize()
			, dataType: "json"
		}).done(function(data){
			var tr = $("tr[data-meaning='detailTr']");
			$(tr).each(function(){$(this).hide();});
			$("#tr-"+uuid).show();
			$("#detail-"+uuid).html("");
			$("#detailView").tmpl(data).appendTo($("#detail-"+uuid));
		});
	}
	
	function cellStyler(value,row,index){
        return 'color:red;font-weight:bold;cursor:pointer;';
    }
	 //$('#baeDangStat').datagrid({singleSelect:(this.value==0)});
	
	</script>
</div>