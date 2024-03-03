*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE BD.SDSA.ENTRY.DETAILS.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine BD.SDSA.ENTRY.DETAILS.FIELDS
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
    CALL Table.defineId("REF.NO", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------
    CALL Table.addField("AC.NUMBER",T24_String,"", "")
    CALL Table.addOptionsField("AC.TYPE","A_L","", "")
    CALL Table.addField("XX<ORG.TRANS.REF.NO",T24_String,"", "")
    CALL Table.addField("XX-ORG.TRANS.CUR",T24_String, "","")
    CALL Field.setCheckFile('CURRENCY')
    CALL Table.addAmountField('XX-ORG.EXCH.RATE','CURRENCY', '', '')
    CALL Table.addField("XX-ORG.PARTICULAR",T24_String, "", "")
    CALL Table.addField("XX-ORG.DATE",T24_Date,"","")
    CALL Table.addOptionsField("XX-ORG.DRCR","DR_CR", "", "")
    CALL Table.addAmountField('XX>ORG.AMT','CURRENCY', Field_AllowNegative, '')
    CALL Table.addField("XX<ADJ.TRANS.REF.NO",T24_String,"", "")
    CALL Table.addField("XX-ADJ.TRANS.CUR",T24_String, "","")
    CALL Field.setCheckFile('CURRENCY')
    CALL Table.addAmountField('XX-ADJ.EXCH.RATE','CURRENCY', '', '')
    CALL Table.addField("XX-ADJ.PARTICULAR",T24_String, "", "")
    CALL Table.addField("XX-ADJ.DATE",T24_Date,"","")
    CALL Table.addOptionsField("XX-ADJ.DRCR","DR_CR", "", "")
    CALL Table.addAmountField('XX>ADJ.AMT','CURRENCY',Field_AllowNegative, '')
    CALL Table.addAmountField('TOT.ORG.AMT','CURRENCY',Field_AllowNegative, '')
    CALL Table.addAmountField('TOT.ADJ.AMT','CURRENCY',Field_AllowNegative, '')
    CALL Table.addAmountField('OUTSTANDING.AMT','CURRENCY',Field_AllowNegative, '')
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
