* @ValidationCode : MjozMzMyNzM1NjQ6Q3AxMjUyOjE1NzEwNjUzNzQ3NzA6REVMTDotMTotMTowOjA6dHJ1ZTpOL0E6UjE3X0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 14 Oct 2019 21:02:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : DELL
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R17_AMR.0
*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE BD.SCT.CAPTURE.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine BD.SCT.CAPTURE.FIELDS
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
    $USING ST.CurrencyConfig
    $USING ST.Customer
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("SCT.REC.ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------
    CALL Table.addField("CONTRACT.TYPE", T24_String, "", "") ;* Add a new fields
    CALL Table.addField("CONTRACT.NUMBER", T24_String, "", "") ;* Add a new fields
    CALL Table.addFieldDefinition("CONTRACT.DATE", "12", "D", "")
    CALL Table.addFieldDefinition("TENOR.DAYS", "5", "", "")
    CALL Table.addField("BENEFICIARY.CUSTNO", T24_Customer, "", "") ;* Add a new fields
    CALL Field.setCheckFile("CUSTOMER")
    CALL Table.addField("APPLICANT.CUSTNO", T24_Customer, "", "") ;* Add a new fields
    CALL Field.setCheckFile("CUSTOMER")
    CALL Table.addField("XX.BUYER.NAME", T24_String, "", "") ;* Add a new fields
    CALL Table.addField("ISSUING.BK.CUSTNO", T24_Customer, "", "") ;* Add a new fields
    CALL Field.setCheckFile("CUSTOMER")
    CALL Table.addField("XX.ISSUE.BANK.NAME", T24_String, "", "") ;* Add a new fields
    CALL Table.addFieldDefinition('CURRENCY', '3.1', 'CCY', '') ;* Add a new fields
    CALL Field.setCheckFile("CURRENCY")
    CALL Table.addFieldDefinition('CONTRACT.AMT', '19.1', 'AMT', '') ;* Add a new fields
    CALL Table.addAmountField('CONTRACT.USE.AMT', 'CURRENCY', 'Field_AllowNegative', '')
    CALL Table.addAmountField('CONTRACT.AMT.NAU', 'CURRENCY', 'Field_AllowNegative', '')
    CALL Table.addAmountField('CONTRACT.AVAIL.AMT', 'CURRENCY', 'Field_AllowNegative', '')
    CALL Table.addFieldDefinition("SHIPMENT.DATE", "12", "D", "")
    CALL Table.addFieldDefinition("EXPIRY.DATE", "12", "D", "")
    CALL Table.addAmountField('FREIGHT.CHARGES', 'CURRENCY', 'Field_AllowNegative', '')
    CALL Table.addAmountField('FOREIGN.CHARGES', 'CURRENCY', 'Field_AllowNegative', '')
    CALL Table.addAmountField('LOC.AGENT.COMM', 'CURRENCY', 'Field_AllowNegative', '')
    CALL Table.addAmountField('NET.FOB.VALUE', 'CURRENCY', 'Field_AllowNegative', '')
    CALL Table.addFieldDefinition("BTB.ENT.RATE", "5", "R", "")
    CALL Table.addAmountField('BTB.ENT.AMT', 'CURRENCY', 'Field_AllowNegative', '')
    CALL Table.addFieldDefinition("PCECC.ENT.RATE", "5", "R", "")
    CALL Table.addAmountField('PCECC.ENT.AMT', 'CURRENCY', 'Field_AllowNegative', '')
    CALL Table.addField("JOB.CURRENCY", T24_String, "", "") ;* Add a new fields
    CALL Field.setCheckFile("CURRENCY")
    CALL Table.addFieldDefinition("JOB.EXCHG.RATE", "5", "R", "")
    CALL Table.addOptionsField("NEW.EXIST.JOB.NO", "NEW_EXIST", "", "")
    CALL Table.addField("BTB.JOB.NO", T24_String, "", "") ;* Add a new fields
    CALL Field.setCheckFile("BD.BTB.JOB.REGISTER")
    CALL Table.addAmountField('TOT.CONT.ENT.AMT', 'CURRENCY', 'Field_AllowNegative', '')
    CALL Table.addField("XX<REP.ELC.NO", T24_String, "", "")
	CALL Table.addFieldDefinition("XX-REP.ELC.DATE", "12", "D", "")
    CALL Table.addAmountField('XX>ELC.COVERED.AMT', 'CURRENCY', 'Field_AllowNegative', '')
    CALL Table.addReservedField('RESERVED.15')
    CALL Table.addReservedField('RESERVED14')
    CALL Table.addReservedField('RESERVED.13')
    CALL Table.addReservedField('RESERVED.12')
    CALL Table.addReservedField('RESERVED.11')
    CALL Table.addField("COMD.ID", T24_String, "", "")
    CALL Field.setCheckFile("BD.LC.COMMODITY")
    CALL Table.addFieldDefinition("XX.COMD.DESC", "65", "A", "")
    CALL Table.addField("COMD.QTY", T24_Numeric, "", "")
    CALL Table.addField("COMD.UNIT", T24_String, "", "")
    CALL Field.setCheckFile("BD.LC.UNITCODE")
    CALL Table.addAmountField('COMD.UNIT.PRICE', 'CURRENCY', '', '')
    CALL Table.addField("XX<HS.CODE", T24_String, "", "")
    CALL Field.setCheckFile("BD.HS.CODE.LIST")
    CALL Table.addField("XX-HS.QTY", T24_Numeric, "", "")
    CALL Table.addField("XX-HS.UNIT", T24_String, "", "")
    CALL Field.setCheckFile("BD.LC.UNITCODE")
    CALL Table.addAmountField('XX>HS.UPRICE', 'CURRENCY', '', '')
    CALL Table.addField("IMPORTER.COUNTRY", T24_String, "", "")
    CALL Field.setCheckFile("COUNTRY")
    CALL Table.addReservedField('RESERVED.10')
    CALL Table.addReservedField('RESERVED.9')
    CALL Table.addReservedField('RESERVED.8')
    CALL Table.addReservedField('RESERVED.7')
    CALL Table.addReservedField('RESERVED.6')
    CALL Table.addOptionsField("REPLACE.ALLOW.YN", "YES_NO", "", "")
    CALL Table.addOptionsField("FULLY.REPLACE.YN", "YES_NO", "", "")
    CALL Table.addAmountField('COLL.AWAIT.AMT', 'CURRENCY', 'Field_AllowNegative', '')
    CALL Table.addField("XX.COLL.TF.ID", T24_String, "", "")
    CALL Field.setCheckFile("LETTER.OF.CREDIT")
    CALL Table.addOptionsField("FULLY.UTILIZED.YN", "YES_NO", "", "")
    CALL Table.addFieldDefinition("LEGACY.SCT.ID", "15", "A", "")
    CALL Table.addOptionsField("BUYER.CRD.REPORT", "YES_NO", "", "")
    CALL Table.addField("CREDIT.REF.NO", T24_String, "", "")
    CALL Table.addReservedField('RESERVED.5')
    CALL Table.addReservedField('RESERVED.4')
    CALL Table.addReservedField('RESERVED.3')
    CALL Table.addReservedField('RESERVED.2')
    CALL Table.addReservedField('RESERVED.1')
*-------------------Excess Replace Amt----------------------------------------------------------
    CALL Table.addAmountField('EXCESS.REPLACE.AMT', 'CURRENCY', 'Field_AllowNegative', '')
    CALL Table.addAmountField('TOT.ELC.COVERED.AMT', 'CURRENCY', 'Field_AllowNegative', '')
    CALL Table.addFieldDefinition("ISS.BANK.REF", "16", "A", "")
*-----------------------------------------------------------------------------
    CALL Table.addField("XX.LOCAL.REF", T24_String, Field_NoInput,"")
    CALL Table.addOverrideField
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
RETURN
*-----------------------------------------------------------------------------
END
