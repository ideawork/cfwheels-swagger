<cfoutput>

<cfparam name="cols" default="#ArrayNew(1)#">
<cfparam name="filename" default="">
<cfparam name="path" default="">

<cfset swagger = createObject("component", "plugins.swagger.Swagger")>
<cfset controllers = swagger.listControllers()>
<cfset models = swagger.listModels()>

<cfif IsDefined("params.model")>
  <cfset m = model(params.model)>
  <cfset props = m.propertyNames()>
  <cfset path = ReReplace(hyphenize(pluralize(params.model)), "-", "_")>
  <cfset filename = ReReplace(titleize(hyphenize(pluralize(params.model))), "-", "_")>
</cfif>

<cfif IsDefined("params.submitted")>
  <cfset swagger.createPath(params=params)>
</cfif>

<link href="/plugins/swagger/vendor/swagger/css/reset.css" rel="stylesheet" type="text/css"/>
<link href="/plugins/swagger/vendor/swagger/css/screen.css" rel="stylesheet" type="text/css"/>
<link href="/plugins/swagger/libs/style.css" rel="stylesheet" type="text/css"/>

<script src="/plugins/swagger/vendor/swagger/lib/shred.bundle.js" type="text/javascript"></script>
<script src="/plugins/swagger/vendor/swagger/lib/jquery-1.8.0.min.js" type="text/javascript"></script>
<script src="/plugins/swagger/vendor/swagger/lib/jquery.slideto.min.js" type="text/javascript"></script>
<script src="/plugins/swagger/vendor/swagger/lib/jquery.wiggle.min.js" type="text/javascript"></script>
<script src="/plugins/swagger/vendor/swagger/lib/jquery.ba-bbq.min.js" type="text/javascript"></script>
<script src="/plugins/swagger/vendor/swagger/lib/handlebars-1.0.0.js" type="text/javascript"></script>
<script src="/plugins/swagger/vendor/swagger/lib/underscore-min.js" type="text/javascript"></script>
<script src="/plugins/swagger/vendor/swagger/lib/backbone-min.js" type="text/javascript"></script>
<script src="/plugins/swagger/vendor/swagger/lib/swagger.js" type="text/javascript"></script>
<script src="/plugins/swagger/vendor/swagger/lib/swagger-client.js" type="text/javascript"></script>
<script src="/plugins/swagger/vendor/swagger/lib/highlight.7.3.pack.js" type="text/javascript"></script>
<script src="/plugins/swagger/vendor/swagger/swagger-ui.min.js" type="text/javascript"></script>
<script src="/plugins/swagger/vendor/jquery.idTabs.min.js" type="text/javascript"></script>

<script type="text/javascript">
  var spec = #swagger.getSpec()#;
</script>

<script src="/plugins/swagger/libs/scripts.js" type="text/javascript"></script>

<h1><a href="">Swagger for Wheels</a></h1>

<br/>

<div id="tab-container" class="tab-container">
  <ul class="tabs">
    <li><a href="##tabs1">Resources</a></li>
    <li><a href="##tabs2">Console</a></li>
  </ul>
  <div id="tabs1">
    <br/>
    <form id="endpoint" method="post">

      <h1>Add Endpoint</h1>
      <br/>

      <label>Model
        <select id="model" name="model">
          <option>- Select Model -</option>
          <cfloop query="models">
            <cfset model = Replace(name, ".cfc", "")>
            <option value="#model#" <cfif IsDefined("params.model") && params.model eq model>selected</cfif>>#model#</option>
          </cfloop>
        </select>
      </label>
      <br/><br/>

      <cfif IsDefined("params.model")>

        <input id="submitted" type="hidden" name="submitted" value="1"/>

        <label>Base Path
          <input name="base" value="/api/"/>
        </label>
        <br/><br/>

        <label>API Version
          <input name="version" value="1"/>
        </label>
        <br/><br/>

        <label>Controller
          <input name="extends" value="plugins.swagger.API"/>
        </label>
        <br/><br/>

        <label>Limit
          <input name="limit" value="1000"/>
        </label>
        <br/><br/>

        <label>File name
          <input name="filename" value="#filename#.cfc"/>
        </label>
        <br/><br/>

        <label>Path
          <input name="path" value="#path#"/>
        </label>
        <br/><br/>

        <h2>Operations</h2>
        <br/>

        <label>
          <input id="all" type="checkbox" name="operations" value="" checked/> All
        </label>
        <label>
          <input type="checkbox" name="operations" value="get" checked/> Get
        </label>
        <label>
          <input type="checkbox" name="operations" value="post" checked/> Create
        </label>
        <label>
          <input type="checkbox" name="operations" value="put" checked/> Update
        </label>
        <label>
          <input type="checkbox" name="operations" value="delete" checked/> Delete
        </label>
        <br/><br/>

        <h2>Fields</h2>
        <br/>

        <label>Default Fields<br/>
          <textarea name="fields" rows="8">#props#</textarea>
        </label>
        <br/><br/>

        <label>Allow Fields<br/>
          <textarea name="allowed" rows="8">#props#</textarea>
        </label>
        <br/><br/>

        <label>Exclude Fields<br/>
          <textarea name="excluded" rows="3"></textarea>
        </label>
        <br/><br/>

        <input type="submit" value="Submit"/>
      </cfif>
    </form>
  </div>
  <div id="tabs2">
    <div id="message-bar" class="swagger-ui-wrap">&nbsp;</div>
    <div class="swagger-section">
      <div id="swagger" class="swagger-ui-wrap"></div>
    </div>
  </div>
</div>

</cfoutput>