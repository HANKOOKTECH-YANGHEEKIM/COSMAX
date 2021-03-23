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
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();
	
	//-- 검색값 셋팅
	BeanResultMap requestMap 	= (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	
	//-- 결과값 셋팅
	BeanResultMap responseMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);	
	
	//-- 파라메터 셋팅
	String actionCode 			= responseMap.getString(CommonConstants.ACTION_CODE);
	String modeCode 			= responseMap.getString(CommonConstants.MODE_CODE);

	boolean is_src_download	= (modeCode.indexOf("_SRC") > -1 ? true : false);
	String type_code 		= "";
	String file_name 		= "";
	String file_savename 	= "";
	String file_path 		= "";
	String file_dec_path 	= "";
	String file_ext 		= "";
	if ("FILE_DOWNLOAD".equals(modeCode)) {
		String markUpText	= (String)responseMap.get("MARKUP_TEXT");
		SQLResults downloadResult	= responseMap.getResult("DOWNLOAD"); 
		
		type_code		= downloadResult.getString(0, "type_code");
		file_name 		= downloadResult.getString(0, "file_name");
		file_savename	= downloadResult.getString(0, "file_savename");				
		file_path 		= CommonProperties.getAttachmentDefaultSavePath();
		file_ext 		= FileUtil.getFileExt(file_name);
		if (!"".equals(type_code)) file_path += "/"+ type_code;
		
		file_dec_path	= file_path;
		file_path += "/"+ file_savename;
		file_dec_path += "/DEC/"+ file_savename;
	} else if ("ZIP_DOWNLOAD".equals(modeCode)) {

		type_code		= responseMap.getString("TYPE_CODE");
		file_name 		= responseMap.getString("FILE_NAME");
		file_savename	= responseMap.getString("FILE_SAVENAME");
		file_path 		= CommonProperties.getAttachmentDefaultSavePath();
		file_ext 		= FileUtil.getFileExt(file_name);
		if (!"".equals(type_code)) file_path += "/"+ type_code;

		file_dec_path	= file_path;
		file_path += "/"+ file_savename;
		file_dec_path += "/DEC/"+ file_savename;
		
	} else if ("FILE_SRC".equals(modeCode)) {
		type_code			= responseMap.getString("type_code");
		file_savename		= responseMap.getString("file_savename");
		file_name			= (!"".equals(responseMap.getString("file_name")) ? StringUtil.unescape(responseMap.getString("file_name")) : file_savename);
		file_path 			= CommonProperties.getAttachmentDefaultSavePath();
		if (!"".equals(type_code)) file_path += "/"+ type_code;
		file_dec_path	= file_path;
		file_path += "/"+ file_savename;
		file_dec_path += "/DEC/"+ file_savename;
		
	} else if ("DIRECT_FILE_DOWNLOAD".equals(modeCode) || "DIRECT_FILE_SRC".equals(modeCode)) {
		type_code			= responseMap.getString("type_code");		
		file_name			= responseMap.getString("file_name");
		file_path			= CommonProperties.getAttachmentDefaultSavePath() +"/"+ type_code +"/"+ file_name;
		
	} else if ("FORM_DOWNLOAD".equals(modeCode) || "FORM_SRC".equals(modeCode)) {
		type_code			= responseMap.getString("type_code");		
		file_name			= responseMap.getString("file_name");
		file_path			= CommonProperties.getFormDefaultPath() +"/"+ type_code +"/"+ file_name;
		
	} else if ("IF_DOWNLOAD".equals(modeCode)) {
		// 제공받은 URL로 파일 다운로드
		file_path = request.getParameter("url");
	}
	
	System.out.println("##### file_name => "+ file_name);
	System.out.println("##### file_path => "+ file_path);
	
 	out.clear(); // 	 이게 없으면  getOutputStream() has already been called for this response   exception 발생.  2009.11.10 	    
 	File file = new File(file_path);
 	File file_dec = new File(file_dec_path);
 	if(file_dec.exists()){
 		FileInputStream fin = null;
 		ServletOutputStream outs = null;

 		try {
 			fin = new FileInputStream(file_dec);

 			int ifilesize = (int)file_dec.length();
 			//byte b[] = new byte[(int) file_dec.length()]; /////////////////////////////////
			byte b[] = new byte[2048];
			
 			response.reset();
 			 			
 			String down_file_name = FileUtil.getAttachmentFilename(request, file_name, "UTF-8");			
 			System.out.println("##### down_file_name => "+ down_file_name); 			
 			
 			//-- 원본 포맷대로 다운로드하는 경우가 아니면 무조건 다운로드하도록 헤더 수정! 			 			
 			if (!is_src_download) {
 				response.setContentType("application/octet-stream; charset=UTF-8"); 				
 				//response.setHeader("Content-Disposition", "attachment; filename=\""+ down_file_name +"\"; filename*=\"UTF-8''"+ StringUtil.encodeURIComponent(file_name) +"\"");
 				response.setHeader("Content-Disposition", "attachment; filename=\""+ down_file_name +"\"");
 			} else {
 				if ( ".hwp".equals(file_name.substring(file_name.length() - 4).toLowerCase()) ) 
 				{
 					response.setContentType("application/x-hwp; charset=UTF-8");	
 				}
 				
 				response.setHeader("Content-Disposition", "filename=\""+ down_file_name +"\"");
 			}

 			response.setHeader("Content-Length", ""+ ifilesize); 			
 			response.setHeader("Content-Transfer-Encoding", "binary;");
 			response.setHeader("Pragma", "no-cache;");
 			response.setHeader("Expires", "-1;");
 			
 			outs = response.getOutputStream();
 			if (ifilesize > 0 && file_dec.isFile()) {
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

 	}else if (file.exists()) {
 		FileInputStream fin = null;
 		ServletOutputStream outs = null;

 		try {
 			fin = new FileInputStream(file);

 			int ifilesize = (int)file.length();
 			//byte b[] = new byte[(int) file.length()]; ///////////////////////////////////////////
			byte b[] = new byte[2048];
			
 			response.reset();
 			 			
 			String down_file_name = FileUtil.getAttachmentFilename(request, file_name, "UTF-8");			
 			System.out.println("##### down_file_name => "+ down_file_name); 			
 			
 			//-- 원본 포맷대로 다운로드하는 경우가 아니면 무조건 다운로드하도록 헤더 수정! 			 			
 			if (!is_src_download) {
 				response.setContentType("application/octet-stream; charset=UTF-8"); 				
 				//response.setHeader("Content-Disposition", "attachment; filename=\""+ down_file_name +"\"; filename*=\"UTF-8''"+ StringUtil.encodeURIComponent(file_name) +"\"");
 				response.setHeader("Content-Disposition", "attachment; filename=\""+ down_file_name +"\"");
 			} else {
 				if ( ".hwp".equals(file_name.substring(file_name.length() - 4).toLowerCase()) ) 
 				{
 					response.setContentType("application/x-hwp; charset=UTF-8");
 					
 				}else if("xls".equals(file_ext.toLowerCase()) || "xlsx".equals(file_ext.toLowerCase())){
 					response.setContentType("application/vnd.ms-excel");	
 					
 				}else if("ppt".equals(file_ext.toLowerCase()) || "pptx".equals(file_ext.toLowerCase())){
 					response.setContentType("application/vnd.ms-powerpoint");	
 					
 				}else if("pdf".equals(file_ext.toLowerCase())){
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