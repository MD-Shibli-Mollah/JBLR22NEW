* @ValidationCode : MjotMTU5MjA4NTQ4MjpDcDEyNTI6MTY2MTU5NzgyMzQyNzpuYXppYjotMTotMTowOjA6dHJ1ZTpOL0E6UjIxX1NQOS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Aug 2022 16:57:03
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
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE JBL.H.BK.MCD.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine JBL.H.BK.MCD.FIELDS
*
* @author monwar@janatabank-bd.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
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
    CALL Table.defineId("MCD.BK", T24_String)     ;* Define Table id
*-----------------------------------------------------------------------------
    CALL Table.addFieldDefinition("XX<CREDIT.ACCT.NO", "16", ".ALLACCVAL", "")
    CALL Table.addField("XX-CR.AC.TITLE", "ANY",Field_NoInput,"")
    CALL Table.addAmountField("XX-CREDIT.AMOUNT", "CURRENCY", "", "")
    CALL Table.addField("XX-CREDIT.CURRENCY", T24_String, "", "")
    CALL Field.setCheckFile('CURRENCY')
    CALL Table.addField("XX-CREDIT.VALUE.DATE", T24_Date, "", "")
    CALL Table.addFieldDefinition("XX-CR.PAYMENT.DETAILS","35","ANY","")
    CALL Table.addFieldDefinition("XX-CR.REF.NO","35","ANY","")
    CALL Table.addFieldDefinition("XX-CR.PAYEE.NAME","35","ANY","")
    CALL Table.addField("XX-CR.OFS.ERR.Y.N","ANY",Field_NoInput,"")
    CALL Table.addFieldDefinition("XX-CR.FT.REF","ANY",Field_NoInput,"")
    CALL Table.addFieldDefinition("XX<DEBIT.ACCT.NO", "16", ".ALLACCVAL", "")
    CALL Table.addField("XX-DR.AC.TITLE", "ANY",Field_NoInput,"")
    CALL Table.addAmountField("XX-DEBIT.AMOUNT", "CURRENCY", "", "")
    CALL Table.addField("XX-DEBIT.CURRENCY", T24_String, "", "")
    CALL Field.setCheckFile('CURRENCY')
    CALL Table.addField("XX-DEBIT.VALUE.DATE", T24_Date, "", "")
    CALL Table.addField("XX-CHEQUE.NUMBER", T24_Numeric, "", "")
    CALL Table.addFieldDefinition("XX-DR.PAYMENT.DETAILS","35","ANY","")
    CALL Table.addFieldDefinition("XX-DR.REF.NO","35","ANY","")
    CALL Table.addFieldDefinition("XX-DR.PAYEE.NAME","35","ANY","")
    CALL Table.addField("XX-DR.OFS.ERR.Y.N","ANY",Field_NoInput,"")
    CALL Table.addFieldDefinition("XX-DR.FT.REF","ANY",Field_NoInput,"")
*-----------------------------LOCAL REF FIELD---------------------------------
    CALL Table.addField('XX.LOCAL.REF', "ANY", Field_NoInput,'')
*--------------------------------RESERVED-------------------------------------
    CALL Table.addReservedField('RESERVED.05')
    CALL Table.addReservedField('RESERVED.04')
    CALL Table.addReservedField('RESERVED.03')
    CALL Table.addReservedField('RESERVED.02')
    CALL Table.addReservedField('RESERVED.01')
*---------------------------------OVERRIDE------------------------------------
    CALL Table.addOverrideField
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition         ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
