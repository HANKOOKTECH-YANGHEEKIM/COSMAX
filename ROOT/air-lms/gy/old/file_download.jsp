<%@ page language="java" pageEncoding="UTF-8"%>   
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale = loginUser.getSiteLocale();
	
	//-- 검색값 셋팅
	BeanResultMap requestMap = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	
	//-- 결과값 셋팅
	BeanResultMap responseMap = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);	
	
	//-- 파라메터 셋팅
	String actionCode = responseMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = responseMap.getString(CommonConstants.MODE_CODE);

	boolean is_src_download	= (modeCode.indexOf("_SRC") > -1 ? true : false);
	String file_name 		= "";
	String file_path 		= "";
	String file_dec_path 	= "";
	
	if ("FILE_DOWNLOAD".equals(modeCode)) {
		SQLResults downloadResult = responseMap.getResult("DOWNLOAD"); 
		
		file_name = downloadResult.getString(0, "FILE_NAME");
		file_path = downloadResult.getString(0, "FILE_PATH");
		//file_dec_path  = downloadResult.getString(0, "file_path"); //암호해 놓은 파일을 해독해야 하는 경우 사용하는 경로
	}

	file_path = StringUtil.replace(file_path, "W:", "//172.29.28.21/vol_4");
		
 	out.clear(); // 	 이게 없으면  getOutputStream() has already been called for this response   exception 발생.  2009.11.10
 	
 	File file = new File(file_path);

 	if (file.exists()) {
 		FileInputStream fin = null;
 		ServletOutputStream outs = null;
 		
 		try {
 			fin = new FileInputStream(file);

 			int ifilesize = (int)file.length();
 			//byte b[] = new byte[(int) file_dec.length()]; /////////////////////////////////
			byte b[] = new byte[2048];
 			
 			response.reset();
 			 			
 			String down_file_name = FileUtil.getAttachmentFilename(request, file_name, "UTF-8");		
 			
 			//-- 원본 포맷대로 다운로드하는 경우가 아니면 무조건 다운로드하도록 헤더 수정! 			 			
 			if (!is_src_download) {
 				response.setContentType("application/octet-stream; charset=UTF-8"); 				
 				//response.setHeader("Content-Disposition", "attachment; filename=\""+ down_file_name +"\"; filename*=\"UTF-8''"+ StringUtil.encodeURIComponent(file_name) +"\"");
 				response.setHeader("Content-Disposition", "attachment; filename=\""+ down_file_name +"\"");
 			} else {
 				if ( ".hwp".equals(file_name.substring(file_name.length() - 4).toLowerCase()) ) 
 				{
 					response.setContentType("application/x-hwp; charset=UTF-8");
 					
 				}else if("xls".equals(file_name.substring(file_name.length() - 4).toLowerCase()) || "xlsx".equals(file_name.substring(file_name.length() - 4).toLowerCase())){
 					response.setContentType("application/vnd.ms-excel");	
 					
 				}else if("ppt".equals(file_name.substring(file_name.length() - 4).toLowerCase()) || "pptx".equals(file_name.substring(file_name.length() - 4).toLowerCase())){
 					response.setContentType("application/vnd.ms-powerpoint");	
 					
 				}else if("pdf".equals(file_name.substring(file_name.length() - 4).toLowerCase())){
 					response.setContentType("application/pdf");	
 					
 				}
 				
 				response.setHeader("Content-Disposition", "filename=\""+ down_file_name +"\"");
 			}

 			response.setHeader("Content-Length", ""+ ifilesize); 			
 			response.setHeader("Content-Transfer-Encoding", "binary;");
 			response.setHeader("Pragma", "no-cache;");
 			response.setHeader("Expires", "-1;");
 			
 			outs = response.getOutputStream();
 			if (ifilesize > 0 && file.isFile()) {
 				int read = 0;

 				while ((read = fin.read(b)) != -1) {
 					outs.write(b, 0, read);
 				}
 			} 			 		            
 		} catch (Exception e) {
 			e.printStackTrace();
 			out.clear();
 			if (!is_src_download) { 							
				response.reset();
				response.setContentType("text/html; charset=UTF-8");
				out.println("<script type=\"text/javascript\">");
				out.println("alert('파일 다운로드 도중 오류가 발생했습니다.\\n시스템 관리자에게 문의 바랍니다.');");
				out.println("</script>");
			}
 		} finally {
 			try {
 				if (outs != null)
 					outs.close();
 				if (fin != null)
 					fin.close();
 			} catch (Exception e) {
 			}
 		}         	

 	} else {
 		out.clear();
 		if (!is_src_download) {			
			response.reset();
			response.setContentType("text/html; charset=UTF-8");
			out.println("<script type=\"text/javascript\">");
			out.println("alert('요청하신 파일이 더이상 존재하지 않습니다.');");
			out.println("</script>");
		}
 	}
%>