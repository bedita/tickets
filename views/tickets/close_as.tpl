<div id="closeDialogContainer" style="padding: 20px;">
    <table class="indexlist">
        <tbody>
        {foreach from=$closeStatus item="label" key="k"}
            <tr>
                <td style="width:15px; vertical-alig:middle; padding:0px 0px 0px 10px;">
                    <input type="radio" name="closeAs" value="{$label}"{if $k == 0} checked{/if}/>
                </td>
                <td>{$label}</td>
            </tr>
        {/foreach}
        </tbody>
    </table>

    <div class="modalcommands">
        <input class="bemaincommands" type="button" value="{t}Close{/t}" name="close" id="closeTicket" />
    </div>
</div>