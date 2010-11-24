{*
** tickets form template
*}

<form action="{$html->url('/tickets/save')}" method="post" name="updateForm" id="updateForm" class="cmxform">
<input type="hidden" name="data[id]" value="{$object.id|default:''}"/>

{if ($conf->mce|default:true)}
	
	{$javascript->link("tiny_mce/tiny_mce", false)}
	{$javascript->link("tiny_mce/tiny_mce_default_init", false)}

{elseif ($conf->wymeditor|default:true)}

	{$javascript->link("wymeditor/jquery.wymeditor.pack", false)}
	{$javascript->link("wymeditor/wymeditor_default_init", false)}

{/if}


{* title and description *}

{assign var="newtitle" value=$html->params.named.title|default:''}

<div class="tab"><h2>{t}Title{/t}</h2></div>

<fieldset id="title">

	<label>{t}title{/t}:</label>
	<br />
	<input type="text" name="data[title]" value="{$object.title|escape:'html'|escape:'quotes'|default:$newtitle}" id="titleBEObject" />
	<br />
	<label>{t}description{/t}:</label>
	<br />
	<textarea id="subtitle" class="mce" style="height:280px" name="data[description]">{$object.description|default:''|escape:'html'}</textarea>

</fieldset>

{$view->element("form_categories")}

{$view->element("form_custom_properties")}

<div class="tab"><h2>{t}Properties{/t}</h2></div>

<fieldset id="properties">			
				
	<table class="bordered">
		
	<tr>

		<th>{t}status{/t}:</th>
		<td colspan="4">
			{if $object.fixed}
				{t}This object is fixed - some data is readonly{/t}
				<input type="hidden" name="data[status]" value="{$object.status}" />
			{else}
				{html_radios name="data[status]" options=$conf->statusOptions selected=$object.status|default:$conf->defaultStatus separator="&nbsp;"}
			{/if}
			
			{if in_array('administrator',$BEAuthUser.groups)}
				&nbsp;&nbsp;&nbsp; <b>fixed</b>:&nbsp;&nbsp;<input type="checkbox" name="data[fixed]" value="1" {if !empty($object.fixed)}checked{/if} />
			{else}
				<input type="hidden" name="data[fixed]" value="{$object.fixed}" />
			{/if}
		</td>
	</tr>
	
				
	
		{if !(isset($publication)) || $publication}
	
		<tr>
			<td colspan="2">
				{t}scheduled from{/t}:&nbsp;
				
				
				<input size="10" type="text" style="vertical-align:middle"
				class="dateinput" name="data[start_date]" id="start"
				value="{if !empty($object.start_date)}{$object.start_date|date_format:$conf->datePattern}{/if}" />
				&nbsp;
				
				{t}to{/t}:&nbsp;
				
				<input size="10" type="text" 
				class="dateinput" name="data[end_date]" id="end"
				value="{if !empty($object.end_date)}{$object.end_date|date_format:$conf->datePattern}{/if}" />
	
			</td>
		</tr>
	
		{/if}

		<tr>
			<th>{t}created by{/t}:</th>
			<td>{$object.UserCreated.realname|default:''} [ {$object.UserCreated.userid|default:''} ]</td>
		</tr>	
		<tr>
			<th>{t}created on{/t}:</th>
			<td>{$object.created|date_format:$conf->dateTimePattern}</td>
		</tr>	 
		<tr>
			<th style="white-space:nowrap">{t}last modified on{/t}:</th>
			<td>{$object.modified|date_format:$conf->dateTimePattern}</td>
		</tr>
		<tr>
			<th style="white-space:nowrap">{t}last modified by{/t}:</th>
			<td>{$object.UserModified.realname|default:''} [ {$object.UserModified.userid|default:''} ]</td>
		</tr>
		
		<tr>
			<th>{t}assegnato a{/t}:</th>
			<td>
				<input type="text" name="data[creator]" value="{$object.creator}" />
				<input type="hidden" name="data[user_created]" value="{$object.user_created}" />
			</td>
		</tr>
		
		<tr>
			<th>{t}durata{/t}:</th>
			<td>
				<input type="text" name="data[duration]" value="{if !empty($object.duration)}{$object.duration/60}{/if}" />
			</td>
		</tr>
	</table>
	
</fieldset>

</form>

{$view->element("ticket_thread")}
