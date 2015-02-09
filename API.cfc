<cfcomponent extends="controllers.Controller" output="false">

  <cfset this._model = "">
  <cfset this._fields = "">
  <cfset this._conditions = "">
  <cfset this._return = "object">
  <cfset this._limit = 5000>

  <cffunction name="init">
    <cfset provides("xml,json")>
    <cfset filters(through="args", type="before")>
  </cffunction>

  <cffunction name="args">
    <cfset args = {}>
    <cfif StructKeyExists(params, "key")>
      <cfset args.key = params.key>
    <cfelse>
      <!--- fields --->
      <cfif IsNull(params.fields)>
        <cfset args.select = ArrayToList(this._fields)>
      <cfelse>
        <cfset args.select = ArrayToList(application._.without(ListToArray(params.fields), this._excluded))>
      </cfif>

      <!--- return format --->
      <cfif IsNull(params.return)>
        <cfset args.returnAs = this._return>
      <cfelse>
        <cfset args.returnAs = params.return>
      </cfif>

      <!--- paging limit --->
      <cfif IsNull(params.limit)>
        <cfset args.perPage = this._limit>
      <cfelseif IsNumeric(params.limit)>
        <cfset args.perPage = Int(params.limit)>
      <cfelse>
        <cfset args.perPage = this._limit>
      </cfif>

      <!--- paging offset --->
      <cfif IsNull(params.offset)>
        <cfset args.page = 1>
      <cfelseif IsNumeric(params.offset)>
        <cfset args.page = (Int(params.offset / params.limit)) + 1>
      <cfelse>
        <cfset args.page = 1>
      </cfif>
    </cfif>
  </cffunction>

  <cffunction name="addPagingUrls">
    <cfargument name="struct" type="struct" default="#StructNew()#">
    <cfset var withoutPaging = CGI.PATH_INFO & "?" & ReReplace(CGI.QUERY_STRING, "(&limit=\d+)", "")>
    <cfset withoutPaging = ReReplace(withoutPaging, "(&offset=\d+)", "")>
    <cfif IsArray(ARGUMENTS.struct.data)>
      <cfset var count = ArrayLen(ARGUMENTS.struct.data)>
      <cfset ARGUMENTS.struct["count"] = count>
      <cfif count gte args.perPage>
        <cfset ARGUMENTS.struct["next"] = withoutPaging & "&limit=#args.perPage#" & "&offset=" & ((args.page) * args.perPage)>
      </cfif>
    </cfif>
    <cfif args.page gt 1>
      <cfset ARGUMENTS.struct["previous"] = withoutPaging & "&limit=#args.perPage#" & "&offset=" & ((args.page - 2) * args.perPage)>
    </cfif>
  </cffunction>

	<cffunction name="index">
    <cfset var response = {}>
    <cfset data = model(this._model).findAll(argumentCollection = args)>
    <cfset response["data"] = IsBoolean(data) ? ArrayNew(1) : data>
    <cfset addPagingUrls(response)>
    <cfset renderWith(response)>
	</cffunction>

  <cffunction name="show">
    <cfset var record = model(this._model).findByKey(argumentCollection = args)>
    <cfset renderWith(record)>
	</cffunction>

  <cffunction name="beforeCreate">
    <cfargument name="record" type="struct" required="true"/>
    <cfreturn ARGUMENTS.record/>
  </cffunction>

  <cffunction name="create">
    <cfset var record = model(this._model).new(params)>
    <cfset beforeCreate(record)/>

    <cfif record.save(reload=true)>
      <cfset afterCreate(record)>
      <cfset renderWith(record)>
    <cfelse>
      <cfheader statusCode=500 statusText="There was an error creating this record">
      <cfset renderWith(record.allErrors())>
    </cfif>
  </cffunction>

  <cffunction name="afterCreate">
    <cfargument name="record" type="struct" required="false"/>
  </cffunction>

  <cffunction name="beforeUpdate">
    <cfargument name="record" type="struct" required="true"/>
    <cfreturn ARGUMENTS.record/>
  </cffunction>

  <cffunction name="update">
    <cfset var record = model(this._model).findOneById(params.id)>
    <cfset beforeUpdate(record)/>

    <cfif record.save(params)>
      <cfset afterUpdate(record)>
      <cfset renderWith(record)>
    <cfelse>
      <cfheader statusCode=500 statusText="There was an error updating this record">
      <cfset renderWith(record.allErrors())>
    </cfif>
  </cffunction>

  <cffunction name="afterUpdate">
    <cfargument name="record" type="struct" required="false"/>
  </cffunction>

  <cffunction name="beforeDelete">
    <cfargument name="record" type="struct" required="true"/>
    <cfreturn ARGUMENTS.record/>
  </cffunction>

  <cffunction name="delete">
    <cfset var record = model(this._model).findOneById(params.id)>
    <cfset beforeDelete(record)/>

    <cfif record.delete()>
      <cfset afterDelete(record)>
      <cfset renderWith(record)>
    <cfelse>
      <cfheader statusCode=500 statusText="There was an error deleting this record">
      <cfset renderWith(record.allErrors())>
    </cfif>
  </cffunction>

  <cffunction name="afterDelete">
    <cfargument name="record" type="struct" required="false"/>
  </cffunction>

</cfcomponent>