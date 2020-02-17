<cfcomponent displayname="Application" output="no">



	<!--- ================================================================================
											 applicationStart
		  ================================================================================	--->
	<cffunction name="onApplicationStart" returnType="boolean">
		<!--- <cfinclude template="/application/constants.cfm" runonce="false"> --->
		<cfreturn true>
	</cffunction>

	<!--- ================================================================================
											 onCFCRequest
		  ================================================================================	--->
	<cffunction name="onCFCRequest" output="no">  
	    <cfargument type="string" name="cfcname" required=true> 
	    <cfargument type="string" name="method" required=true> 
	    <cfargument type="struct" name="args" required=true> 
		
	    <cfinvoke 
	        component = "#arguments.cfcname#"
	        method = "#arguments.method#"
	        returnVariable = "risultato"
	        argumentCollection = "#arguments.args#" />
            <cfsetting showDebugOutput="no" enablecfoutputonly="true">	        
	        <cfif isdefined('risultato')>
		        <cfif isstruct(risultato) or isquery(risultato)>
		        	<cfwddx action="CFML2WDDX" input="#risultato#" output="risultato"/>
		        </cfif>		
				<cfoutput>#risultato#</cfoutput>
				<cfreturn var="#risultato#" />
			<cfelse>
			</cfif>
			
    </cffunction> 


<!--- ================================================================================
										 onRequestStart
	================================================================================	--->
    <cffunction name="OnRequestStart" returntype="boolean">
        <cfscript>
		</cfscript>
		<cfreturn true>
	</cffunction>


<!--- ================================================================================
										 onRequest
	================================================================================	--->

	<cffunction name="onRequest">
		<cfargument name="targetPage" type="String" required=true/>
        <cfif fileExists(arguments.targetPage)>
            <cfinclude template='/bm/top.cfm'>
            <cfinclude template='#Arguments.targetPage#'>
            <cfinclude template='/bm/bottom.cfm'>
        <cfelse>
            <cfoutput>#throw404(arguments)#</cfoutput>
        </cfif>

	</cffunction>

	<!--- ================================================================================
											 onSessionStart
		  ================================================================================	--->
	<cffunction name="onSessionStart">
	</cffunction>

	<!--- ================================================================================
											 onMissingTemplate
		  ================================================================================	--->
	<cffunction name="onMissingTemplate" returnType="boolean">
	    <cfargument type="string" name="targetPage" required=true/>
	
		<cfoutput>#throw404(Arguments)#</cfoutput>

		<cfreturn false>
	</cffunction>



<!--- ================================================================================
										 ExtraFunctions
	  ================================================================================	--->

	  <cffunction name="throw404">
		<cfargument name="myparams" required="true">
		
		<cftry>
		    <!--- set response to 404 for Search Engine and statistical purposes --->
		    <cfheader 
		       statusCode = "404"
		       statusText = "Page Not Found"
			>
			
				<style>
					div.errore{
						display: block;
						position:absolute;
						left: 10%;
						top:50px;
						background: white;
						padding:10px;
						border:3px solid red;
						box-shadow:3px 3px 6px black;
						width:80%;
						height:80%;
						text-align:center;
						vertical-align: middle;
					}
				</style>

				<cfscript>
					s404 = directoryList(expandPath('/media/404/'),false,"name","*.png");
					x = randRange(1,arrayLen(s404));
					imgname = s404[x];
				</cfscript>
						<div class="errore">
						
							<titolo>Errore 404!!</titolo>
							<testo>
								<p>Pagina non trovata<br>Mi dispiace ma la pagina <strong style="color: green"><cfoutput>#myparams.targetPage#</cfoutput>
								</strong> non l'ho proprio trovata :(</p>
							</testo>
							<pulsanti>
								<cfoutput>
									<p>
										<img src="/media/404/#imgname#" style="border-radius: 200px;box-shadow: 2px 2px 5px rgba(0,0,0,5.6);border: 5px solid rgba(255,255,255,0.6)">
									</p>
									</cfoutput>
								<p><a href="/" class="button gray" style="margin-top: 30px;">Torna alla home</a></p>
							</pulsanti>
						</div>
		   
<!---		   <cfsetting showDebugOutput="no">--->
		    <!--- return true to prevent the default ColdFusion error handler from running --->
		    <cfreturn true />
		   
		    <cfcatch>
		    <!--- If an error occurs within the error handler routine, allow ColdFusion's default error handler to run --->
		        <cfreturn false />
		    </cfcatch>
		</cftry>
	</cffunction>

<!--- ================================================================================
										 403 - FORBIDDEN
	  ================================================================================	--->
	<cffunction name="throw403" output="true">
		<cfargument name="myparams" required="true">

		
		<!--- <cftry> --->
		    <!--- set response to 403 for Search Engine and statistical purposes --->
		    <cfheader 
		       statusCode = "403"
		       statusText = "Forbidden"
			>
			
				<style>
					div.errore{
						display: block;
						position:absolute;
						left: 10%;
						top:50px;
						background: white;
						padding:10px;
						border:3px solid red;
						box-shadow:3px 3px 6px black;
						width:80%;
						height:80%;
						text-align:center;
						vertical-align: middle;
					}
				</style>

				<cfscript>
					
					s403 = directoryList(expandPath('/media/403/'),false,"name","*.png");
					x = randRange(1,arrayLen(s403));
					writedump(arguments);
					imgname = s403[x];
				</cfscript>
						<div class="errore">
						
							<titolo>Errore 403!!</titolo>
							<testo>
								<p>Significa che non puoi accedere a questo indirizzo. Può essere che tu debba ripetere il login se non hai navigato per un po' in maxworks...</p>
								<p><a href="/?logout" class="button gray" style="margin-top: 30px;">Torna alla home</a></p>
								<cfdump var="#request#">
							</testo>
							<pulsanti>
								<cfoutput>
									<p>
										<img src="/media/403/#imgname#" style="border-radius: 200px;box-shadow: 2px 2px 5px rgba(0,0,0,5.6);border: 5px solid rgba(255,255,255,0.6)">
									</p>
									</cfoutput>
							</pulsanti>
						</div>
		   
<!---		   <cfsetting showDebugOutput="no">--->
		    <!--- return true to prevent the default ColdFusion error handler from running --->
		    <cfreturn true />
		   
<!--- 			<cfcatch>
				
		    <!--- If an error occurs within the error handler routine, allow ColdFusion's default error handler to run --->
		        <cfreturn false />
		    </cfcatch>
		</cftry> --->
	</cffunction>



	<!--- ================================================================================
		onApplicationEnd
		<cffunction name="onApplicationEnd"> 
		<cfargument name="ApplicationScope" required=true/>
	</cffunction>
	================================================================================	--->



</cfcomponent>