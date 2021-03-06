<?php
require_once( '../../kernel/setup_inc.php' );
$gBitSystem->verifyPermission( 'p_admin' );

require_once( '../LCConfig.php' );
$LCConfig = LCConfig::getInstance();

// sort services by required state and name to help make the table more legible
foreach( $gBitSystem->mPackagePluginsConfig as $sguid=>$splugin ){
	$required[$sguid] = $splugin['required'] == 'y'?TRUE:FALSE;
	$name[$sguid] = $sguid;
}
array_multisort( $required, SORT_ASC, $name, SORT_ASC, $gBitSystem->mPackagePluginsConfig );

// deal with service preferences
if( !empty( $_REQUEST['save'] ) ) {
	$gBitUser->verifyTicket();
	$LCConfig->mDb->StartTrans();


	// store prefs
	foreach( array_keys( $gLibertySystem->mContentTypes ) as $ctype ) {
		foreach( $gBitSystem->mPackagePluginsConfig as $guid=>$plugin ){
			if( empty( $plugin['required'] ) || $plugin['required'] == 'n' ){
				if( $_REQUEST['service_guids'][$guid][$ctype] == 'n' ){
					// remove
					$LCConfig->expungeConfig( 'service_'.$guid, $ctype );
				} else {
					// affermative or required.
					$LCConfig->storeConfig( 'service_'.$guid, $ctype, $_REQUEST['service_guids'][$guid][$ctype] );
				}
			}
		}
	}

	if( empty( $feedback['error'] ) ){
		$LCConfig->mDb->CompleteTrans();
		$feedback['success'] = tra( "Services preferences were updated." );
		$LCConfig->reloadConfig();
	}
	else{
		$LCConfig->mDb->RollbackTrans();
		$LCConfig->reloadConfig();
	}
}
$gBitSmarty->assign_by_ref( 'feedback', $feedback );

$gBitSmarty->assign_by_ref( 'LCConfigSettings', $LCConfig->getAllConfig() );
$gBitSystem->display( 'bitpackage:lcconfig/admin_services.tpl', tra( 'Set Service Preferences' ), array( 'display_mode' => 'admin' ));
