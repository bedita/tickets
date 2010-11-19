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



<div class="tab"><h2>{t}Properties{/t}</h2></div>

<fieldset id="properties">			
			
<table class="bordered">
	<tr>
		<th>{t}priority{/t}:</th>
		<td colspan="4">
			<select name="data[level]">
				<option>very high (blocking bug)</option>
				<option>high</option>
				<option>medium</option>
				<option>low</option>				
			</select>
		</td>
	</tr>
	<tr>
		<th>{t}type{/t}:</th>
		<td colspan="4">
			<select name="data[type]">
				<option>bug</option>
				<option>enhancement</option>
				<option>newfeature</option>
			</select>
		</td>
	</tr>		
	<tr>
		<th>{t}status{/t}:</th>
		<td colspan="4">
			<input name="data[status]" value="on" type="radio">open &nbsp;
			<input name="data[status]" value="off" checked="checked" type="radio">closed resolved&nbsp;
			<input name="data[status]" value="draft" checked="checked" type="radio">closed unresolved&nbsp;
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
		<th>{t}author{/t}:</th>
		<td>
			<input type="text" name="data[creator]" value="{$object.creator}" />
			<input type="hidden" name="data[user_created]" value="{$object.user_created}" />
		</td>
	</tr>

	<tr>
		<th>{t}assegnato a{/t}:</th>
		<td>
			<input type="text" name="data[assigned_to]" value="{$object.creator}" />
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

	{$view->element("form_print")}