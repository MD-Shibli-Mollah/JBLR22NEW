*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE JBL.CREDIT.CARD.DETAILS.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine JBL.CREDIT.CARD.DETAILS.FIELDS
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
    CALL Table.defineId("CR.CARD.DETAILS.ID", T24_String) ;* Define Table id
    ID.N = "18"
*-----------------------------------------------------------------------------
    CALL Table.addFieldDefinition("CARD.TYPE", "25", "":FM:"LOCAL_INT_DUAL_CARD TYPE_LOCAL PREPAID CARD_DUAL CREDIT CARD TQ_PREPAID DUAL TQ_RFCD DUAL_ERQ DUAL_TQ INT CREDIT CARD_RFCD INT_ERQ INT_TQ PREPAID INT", "")
    CALL Table.addFieldDefinition("CUST.NAME", "35", "T24_String", "")
    CALL Table.addFieldDefinition("LCY", "3", "":FM:"BDT", "")
    CALL Table.addFieldDefinition("ACCOUNT.LCY", "18", "A", "")
    CALL Table.addFieldDefinition("FCY", "3", "":FM:"USD", "")
    CALL Table.addFieldDefinition("ACCOUNT.FCY", "18", "A", "")
    CALL Table.addFieldDefinition("INPUT.DATE", "12", "D", "")
    CALL Table.addReservedField('RESERVED.10')
    CALL Table.addReservedField('RESERVED.09')
    CALL Table.addReservedField('RESERVED.08')
    CALL Table.addReservedField('RESERVED.07')
    CALL Table.addReservedField('RESERVED.06')
    CALL Table.addReservedField('RESERVED.05')
    CALL Table.addReservedField('RESERVED.04')
    CALL Table.addReservedField('RESERVED.03')
    CALL Table.addReservedField('RESERVED.02')
    CALL Table.addReservedField('RESERVED.01')
    CALL Table.addField('XX.LOCAL.REF', T24_String, Field_NoInput,'')
    CALL Table.addOverrideField
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
