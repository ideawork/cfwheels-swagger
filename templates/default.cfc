<cfcomponent extends="[extends]" hint="[description]">

  <cfset this._path = "[path]">
  <cfset this._model = "[model]">
  <cfset this._operations = [[operations]]>
  <cfset this._fields = [[fields]]>
  <cfset this._allowed = [[allowed]]>
  <cfset this._excluded = [[excluded]]>
  <cfset this._limit = [limit]>
  <cfset this._conditions = "">
  <cfset this._return = "object">

  <cffunction name="index">
    <cfset super.index()>
	</cffunction>

  <cffunction name="show">
    <cfset super.show()>
	</cffunction>

  <cffunction name="beforeCreate">
    <cfargument name="record" type="struct" required="true"/>
    <cfreturn ARGUMENTS.record/>
  </cffunction>

  <cffunction name="create">
    <cfset super.create()>
  </cffunction>

  <cffunction name="afterCreate">
    <cfargument name="record" type="struct" required="false"/>
  </cffunction>

  <cffunction name="beforeUpdate">
    <cfargument name="record" type="struct" required="true"/>
    <cfreturn ARGUMENTS.record/>
  </cffunction>

  <cffunction name="update">
    <cfset super.update()>
  </cffunction>

  <cffunction name="afterUpdate">
    <cfargument name="record" type="struct" required="false"/>
  </cffunction>

  <cffunction name="beforeDelete">
    <cfargument name="record" type="struct" required="true"/>
    <cfreturn ARGUMENTS.record/>
  </cffunction>

  <cffunction name="delete">
    <cfset super.delete()>
  </cffunction>

  <cffunction name="afterDelete">
    <cfargument name="record" type="struct" required="false"/>
  </cffunction>

</cfcomponent>