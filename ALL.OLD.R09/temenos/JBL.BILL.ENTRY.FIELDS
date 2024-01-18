*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE JBL.BILL.ENTRY.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine JBL.BILL.ENTRY.FIELDS
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
    CALL Table.defineId("BILL.ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------
    
    CALL Table.addField("TF.DRAWING.ID", T24_String,Field_Mandatory, "")
    CALL Field.setCheckFile('DRAWINGS')
    CALL Table.addField("LC.NUMBER", T24_String, Field_Mandatory, "")
    CALL Table.addField("LC.ISSUE.DATE", T24_Date,Field_Mandatory,"")
    CALL Table.addField("DATE.OF.PAYMENT", T24_Date,Field_Mandatory,"")
    CALL Table.addField("APPLICANT.CUST.NO", T24_Customer, "","")
    CALL Table.addField("XX.APPLICANT.NAME", T24_String,Field_Mandatory,"")
    CALL Table.addField("DOC.CCY", T24_String, Field_Mandatory, "")
    CALL Field.setCheckFile('CURRENCY')
    CALL Table.addAmountField('DOC.AMT', 'CURRENCY', Field_Mandatory, '')
    CALL Table.addField("XX.HS.CODE", T24_String, "", "")
    CALL Field.setCheckFile('BD.HS.CODE.LIST')
    CALL Table.addField("BILL.OF.ENTRY.NO", T24_String,Field_Mandatory, "")
    CALL Table.addField("BOE.ISS.DATE", T24_Date,Field_Mandatory,"")
    CALL Table.addAmountField('BOE.AMT', 'CURRENCY', Field_Mandatory, '')
    CALL Table.addFieldDefinition("BOE.SUBM.DATE","8","D","")
    CALL Table.addField("BOE.QUANTITY", T24_Numeric, "", "")
    CALL Table.addFieldDefinition("BOE.UNIT","20","A","")
    CALL Table.addFieldDefinition("BILL.OF.ENTRY.REC", 3,  "": FM : "YES_NO", "")
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
