{strip}
<div class="admin liberty">
	<div class="header">
		<h1>{tr}Set Services Preferences{/tr}</h1>
	</div>
	<div class="body">
		{formfeedback hash=$feedback}
		{form}
			<div style="width:100%; overflow:auto;">
			<table class="data">
				<caption>{tr}Available Services{/tr}</caption>
				{foreach from=$gBitSystem->mPackagePluginsConfig item=plugin key=plugin_guid}
					{assign var=config_key value=service_$plugin_guid}
					{cycle values="odd,even" assign="rowstyle"}
					<tr class="{$rowstyle}">
						<th class="alignleft" style="text-align:left">{tr}{$plugin_name|ucfirst}{/tr}</th>
						{foreach from=$gLibertySystem->mContentTypes item=ctype key=p name=ctypes}
						<th>
							{$gLibertySystem->getContentTypeName($ctype.content_type_guid)}
						</th>
						{/foreach}
					</tr>
					<tr class="{$rowstyle}">
						{* list the service and its description *}
						<td title="{$plugin_guid}">
							{$plugin.name}<br />
							{tr}(pkg:{$plugin.package_guid|ucfirst}){/tr}<br />
							{$plugin.description}
						</td>
						{if $plugin.required == 'y'}
							<td colspan="{$gLibertySystem->mContentTypes|@count}" style="text-align:center"><em>This is a required service and should not be disabled</em></td>
						{else}
							{foreach from=$gLibertySystem->mContentTypes item=ctype key=p name=ctypes}
								{* create option for each ctype *}
								<td class="aligncenter" style="width:25px; padding:0 15px">
									<select name="service_guids[{$plugin_guid}][{$p}]" id="{$p}_{$plugin_guid}">
										<option value="y" 			{if $LCConfigSettings.$p.$config_key eq 'y'}selected="selected"{/if}				>Include</option>
										<option value="required" 	{if $LCConfigSettings.$p.$config_key eq 'required' }selected="selected"{/if}>Require</option>
										<option value="n" 			{if empty( $LCConfigSettings.$p.$config_key ) || $LCConfigSettings.$p.$config_key eq 'n'}selected="selected"{/if}		>Exclude</option>
									</select>
								</td>
							{/foreach}
						{/if}
					</tr>
				{/foreach}
			</table>
			</div>
			<div class="submit">
				<input class="button" type="submit" name="save" value="{tr}Apply Changes{/tr}" />
			</div>
		{/form}
	</div><!-- end .body -->
</div><!-- end .users -->
{/strip}
