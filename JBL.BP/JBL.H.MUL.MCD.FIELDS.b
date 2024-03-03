* @ValidationCode : MjotMTUxMTU5MjYzNzpDcDEyNTI6MTY2MTMyMjY2NjY5MDpuYXppYjotMTotMTowOjA6dHJ1ZTpOL0E6UjIxX1NQOS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Aug 2022 12:31:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : nazib
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_SP9.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE JBL.H.MUL.MCD.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine JBL.H.MUL.MCD.FIELDS
*
*
*Retrofitted By:
*    Date         : 24/08/2022
*    Developed By : Md. Nazibul Islam (Peal)
*    Designation  : Software Engineer
*    Email        : nazibul.ntl@nazihargroup.com
*    Attached To  :
*
* </doc>
*-----------------------------------------------------------------------------
* Modification History :

*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("MCD.ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------
    CALL Table.addFieldDefinition("XX<CREDIT.ACCT.NO","16.1",".ALLACCVAL", "")
    CALL Field.setCheckFile("ACCOUNT")
    CALL Table.addField("XX-CR.AC.TITLE", "ANY", Field_NoInput, "")
    CALL Table.addAmountField("XX-CREDIT.AMOUNT",'CURRENCY',Field_Mandatory,"")
    CALL Table.addField("XX-CREDIT.CURRENCY", T24_String, "", "")
    CALL Field.setCheckFile("CURRENCY")
    CALL Table.addField("XX-CREDIT.VALUE.DATE",T24_Date,"","")
    CALL Table.addFieldDefinition("XX-CR.PAYMENT.DET", "60", "ANY", "")
    CALL Table.addField("XX-CR.OFS.ERR.Y.N", "ANY", Field_NoInput, "")
    CALL Table.addField("XX>CR.FT.REF", "ANY", Field_NoInput, "")
    CALL Table.addFieldDefinition("XX<DEBIT.ACCT.NO","16.1", ".ALLACCVAL", "")
    CALL Field.setCheckFile("ACCOUNT")
    CALL Table.addField("XX-DR.AC.TITLE", "ANY", Field_NoInput, "")
    CALL Table.addAmountField("XX-DEBIT.AMOUNT",'CURRENCY',Field_Mandatory,"")
    CALL Table.addField("XX-DEBIT.CURRENCY", T24_String, "", "")
    CALL Field.setCheckFile("CURRENCY")
    CALL Table.addField("XX-DEBIT.VALUE.DATE",T24_Date,"","")
    CALL Table.addFieldDefinition("XX-CHEQUE.NUMBER", "15..", "ANY", "")
    CALL Table.addFieldDefinition("XX-DR.PAYMENT.DET", "60", "ANY", "")
    CALL Table.addField("XX-DR.OFS.ERR.Y.N", "ANY", Field_NoInput, "")
    CALL Table.addField("XX>DR.FT.REF", "ANY", Field_NoInput, "")
*-----------------------------LOCAL REF FIELD---------------------------------
    CALL Table.addField('XX.LOCAL.REF', "ANY", Field_NoInput,'')
*--------------------------------RESERVED-------------------------------------
    CALL Table.addReservedField('RESERVED.06')
    CALL Table.addReservedField('RESERVED.05')
    CALL Table.addReservedField('RESERVED.04')
    CALL Table.addReservedField('RESERVED.03')
    CALL Table.addReservedField('RESERVED.02')
    CALL Table.addReservedField('RESERVED.01')
*---------------------------------OVERRIDE------------------------------------
    CALL Table.addOverrideField
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
