<div id="note-{$note.id}" class="js-single-note">
    <table class="editorheader ultracondensed" style="width:100%">
    <tr>
        {bedev}<td> {if !empty($count)}{$count}.{/if} </td>{/bedev}
    	<td class="author">{$note.UserCreated.realname|default:$note.UserCreated.userid|default:$note.creator|default:$note.user_created}</td>
    	<td class="date">{$note.created|date_format:$conf->dateTimePattern}  <a href="#note-{$note.id}" >permalink</a></td>
    </tr>
    </table>
    <p class="editornotes">{$note.description|nl2br}</p>
    {if $note.user_created == $BEAuthUser.id}
    	<input type="button" rel="{$note.id}" style="float: right" name="deletenote" value="{t}delete{/t}" />
	{/if}
</div>