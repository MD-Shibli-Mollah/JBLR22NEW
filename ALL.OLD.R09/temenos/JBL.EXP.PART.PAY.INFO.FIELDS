*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE JBL.EXP.PART.PAY.INFO.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine JBL.EXP.PART.PAY.INFO.FIELDS
*
* @author s.azam@fortress-global.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*-----------------------------------------------------------------------------
    CALL Table.defineId("JBL.EXP.ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------
    CALL Table.addFieldDefinition('XX<FT.TXN.REF','35','','')
    CALL Table.addFieldDefinition('XX-FT.TXN.DATE','12','D','')
    CALL Table.addFieldDefinition('XX-DOC.RECV.CCY', '5', 'A','')
    CALL Table.addAmountField('XX>DOC.RECV.AMT', 'CURRENCY', '','')
    CALL Table.addAmountField('TOTAL.RECV.AMT', 'CURRENCY', '','')
    CALL Table.addFieldDefinition('DOC.REALZ.DATE','12','D','')
    CALL Table.addField('XX.LOCAL.REF', T24_String, Field_NoInput,'')
    CALL Table.addReservedField('RESERVED.05')
    CALL Table.addReservedField('RESERVED.04')
    CALL Table.addReservedField('RESERVED.03')
    CALL Table.addReservedField('RESERVED.02')
    CALL Table.addReservedField('RESERVED.01')
    CALL Table.addOverrideField
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
