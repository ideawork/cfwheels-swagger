<cfcomponent output="false" dependency="coldroute" mixin="none">

  <cffunction name="init" returntype="struct" access="public">
		<cfscript>
			var loc = {};
			this.version = "0.0.1";
      this.createRoutes();
			return this;
		</cfscript>
	</cffunction>

  <cffunction name="listControllers" access="public" returnType="array">
    <cfscript>
      return DirectoryList("#ExpandPath('/')#/controllers/api", true, "name", "*.cfc");
    </cfscript>
  </cffunction>

  <cffunction name="listModels" access="public" returnType="query">
    <cfscript>
      return DirectoryList("#ExpandPath('/')#/models", true, "query", "*.cfc");
    </cfscript>
  </cffunction>

  <cffunction name="createPath" access="public">
    <cfargument name="params">
    <cfscript>
      $copyTemplateAPIAndRename(arguments.params);
    </cfscript>
  </cffunction>

  <cffunction name="createRoutes" access="public">
    <cfscript>
      var controllers = this.listControllers();
      for(var i = 1; i < ArrayLen(controllers); i++){
        //var controller = $createObjectFromRoot(path = "controllers.api.v1", fileName = ReReplace(controllers[i], ".cfc", ""), method = "init");
      }
    </cfscript>
  </cffunction>

  <cffunction name="getSpec" access="public">
    <cfscript>
      var s = {};
      s["swagger"] = "2.0";

      s["info"] = {};
      s.info["description"] = "API Console";
      s.info["version"] = "1.0.0";
      s.info["title"] = "";
      s.info["termsOfService"] = "";
      s.info["contact"] = {};

      s.info.contact["name"] = "";
      s.info["license"] = {};
      s.info.license["name"] = "";
      s.info.license["url"] = "";

      s["host"] = cgi.SERVER_NAME;
      s["basePath"] = "/api/v1";
      s["schemes"] = ["http"];

      s["paths"] = {};

      return SerializeJSON(s);
    </cfscript>
  </cffunction>

  <cffunction name="$copyTemplateAPIAndRename" displayname="$copyTemplateAPIAndRename" access="private" returntype="string">
    <cfargument name="params">

		<cfset var loc = {}>
		<cfset loc.dir = expandPath("controllers/api/") & "/v" & ARGUMENTS.params.version>
    <cfset loc.template = expandPath("plugins/swagger/templates/") & "default.cfc">
		<cfset loc.extends = arguments.params.extends>
    <cfset loc.path = arguments.params.path>
    <cfset loc.model = arguments.params.model>
    <cfset loc.filename = arguments.params.filename>
    <cfset loc.operations = ListQualify(ReReplace(arguments.params.operations, " ", "", "all"), '"')>
    <cfset loc.fields = ListQualify(ReReplace(arguments.params.fields, " ", "", "all"), '"')>
    <cfset loc.allowed = ListQualify(ReReplace(arguments.params.allowed, " ", "", "all"), '"')>
    <cfset loc.excluded = ListQualify(ReReplace(arguments.params.excluded, " ", "", "all"), '"')>
    <cfset loc.limit = arguments.params.limit>

		<cfif not FileExists(loc.template)>
			<cfreturn "Template #arguments.params.template# could not be found">
		</cfif>

		<cfif not DirectoryExists(loc.dir)>
			<cfdirectory action="create" directory="#loc.dir#">
		</cfif>

		<cftry>
			<cffile action="read" file="#loc.template#" variable="loc.templateContent">

			<cfif Len(Trim(application.wheels.rootcomponentpath)) GT 0>
			  <cfset loc.extends = application.wheels.rootcomponentpath & ".plugins.swagger.API">
			</cfif>

			<cfset loc.templateContent = replace(loc.templateContent, "[extends]", loc.extends)>
      <cfset loc.templateContent = replace(loc.templateContent, "[description]", replace("",'"','&quot;','ALL'))>
      <cfset loc.templateContent = replace(loc.templateContent, "[path]", loc.path)>
      <cfset loc.templateContent = replace(loc.templateContent, "[model]", loc.model)>
      <cfset loc.templateContent = replace(loc.templateContent, "[operations]", loc.operations)>
      <cfset loc.templateContent = replace(loc.templateContent, "[fields]", loc.fields)>
      <cfset loc.templateContent = replace(loc.templateContent, "[allowed]", loc.allowed)>
      <cfset loc.templateContent = replace(loc.templateContent, "[excluded]", loc.excluded)>
      <cfset loc.templateContent = replace(loc.templateContent, "[limit]", loc.limit)>

      <cfif not FileExists("#loc.dir#/#loc.filename#.cfc")>
        <cffile action="write" file="#loc.dir#/#loc.filename#" output="#loc.templateContent#">
      </cfif>

			<cfcatch type="any">
				<cfreturn "There was an error when creating the api endpoint: #cfcatch.message#">
			</cfcatch>
		</cftry>
		<cfreturn "The API endpoint #loc.filename# file was created" >
	</cffunction>

</cfcomponent>