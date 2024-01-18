*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE JBL.LTR.INNER.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine JBL.LTR.INNER.FIELDS
*
* @author tcoleman@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 19/10/07 - EN_10003543
*            New Template changes
*
* 14/11/07 - BG_100015736
*            Exclude routines that are not released
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("PAD.ID", T24_String) ;* THIS ID WILL BE A PAD ID.
*-----------------------------------------------------------------------------
    CALL Table.addField("LTR.ID", T24_Account, "", "")
    CALL Table.addFieldDefinition("LTR.CCY", "3", "A", "")
    CALL Table.addFieldDefinition("LTR.AMOUNT", "20", "A", "")
    CALL Table.addFieldDefinition("PAD.UTILIZE", "1", "A", "")
    
    CALL Table.addReservedField('RESERVED.05')
    CALL Table.addReservedField('RESERVED.04')
    CALL Table.addReservedField('RESERVED.03')
    CALL Table.addReservedField('RESERVED.02')
    CALL Table.addReservedField('RESERVED.01')
    
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
RETURN
*-----------------------------------------------------------------------------
END
