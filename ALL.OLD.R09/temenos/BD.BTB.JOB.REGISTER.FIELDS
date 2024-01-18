*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE BD.BTB.JOB.REGISTER.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine BD.BTB.JOB.REGISTER.FIELDS
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
    CALL Table.defineId("BTB.JOB.NO", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------
    CALL Table.addFieldDefinition("CUSTOMER.NO","15","","")
    CALL Field.setCheckFile("CUSTOMER")
    CALL Table.addFieldDefinition("JOB.CREATE.DATE","12","D","")
    CALL Table.addFieldDefinition("JOB.CURRENCY","3","A","")
*
    CALL Table.addField("XX<CONT.REFNO", T24_String, "", "")
    CALL Field.setCheckFile("BD.SCT.CAPTURE")
*
    CALL Table.addFieldDefinition("XX-CONT.ISSUE.DATE","12","D","")
    CALL Table.addFieldDefinition("XX-CONT.CURRENCY","3","A","")
    CALL Table.addAmountField('XX-CONT.AMOUNT','CURRENCY',Field_AllowNegative,'')
    CALL Table.addAmountField('XX-CONT.NET.FOB.VALUE','CURRENCY',Field_AllowNegative,'')
    CALL Table.addFieldDefinition("XX-CONT.SHIPMENT.DATE","12","D","")
    CALL Table.addFieldDefinition("XX-CONT.EXPIRY.DATE","12","D","")
*
    CALL Table.addField("XX-XX<COLL.TF.REFNO", T24_String, "", "")
    CALL Field.setCheckFile("LETTER.OF.CREDIT")
    CALL Table.addField("XX-XX-COLL.DR.REFNO", T24_String, "", "")
    CALL Field.setCheckFile("DRAWINGS")
    CALL Table.addField("XX-XX>COLL.PUR.REFNO", T24_String, "", "")
    CALL Field.setCheckFile("AA.ARRANGEMENT")
    CALL Table.addAmountField("XX-CONT.BTB.ENTLMNT", 'CURRENCY', 'Field_AllowNegative', '')
    CALL Table.addAmountField("XX-CONT.PC.ENTLMNT", 'CURRENCY', 'Field_AllowNegative', '')
    CALL Table.addField("XX>CONT.STATUS", T24_String, "", "")
    CALL Table.addReservedField('XX-RESERVED.40')
    CALL Table.addReservedField('XX-RESERVED.39')
    CALL Table.addReservedField('XX-RESERVED.38')
    CALL Table.addReservedField('XX-RESERVED.37')
    CALL Table.addReservedField('XX-RESERVED.36')
    CALL Table.addReservedField('XX-RESERVED.35')
    CALL Table.addReservedField('XX-RESERVED.34')
    CALL Table.addReservedField('XX-RESERVED.33')
    CALL Table.addReservedField('XX-RESERVED.32')
    CALL Table.addReservedField('XX-RESERVED.31')
*
    CALL Table.addFieldDefinition("XX<EX.TF.REF","20","A","")
    CALL Field.setCheckFile("LETTER.OF.CREDIT")
    CALL Table.addFieldDefinition("XX-EX.ISSUE.DATE","12","D","")
    CALL Table.addFieldDefinition("XX-EX.LC.NUMBER","40","A","")
    CALL Table.addFieldDefinition("XX-EX.LC.CURRENCY","3","A","")
    CALL Table.addAmountField('XX-EX.LC.AMOUNT','CURRENCY',Field_AllowNegative,'')
    CALL Table.addAmountField('XX-EX.NET.FOB.VALUE','CURRENCY',Field_AllowNegative,'')
    CALL Table.addFieldDefinition("XX-EX.BTB.ENT.PER","5","A","")
    CALL Table.addAmountField('XX-EX.BTB.ENT.AMT','CURRENCY',Field_AllowNegative,'')
    CALL Table.addAmountField('XX-EX.BTB.AMT','CURRENCY',Field_AllowNegative,'')
    CALL Table.addAmountField('XX-EX.BTB.AVL.AMT','CURRENCY',Field_AllowNegative,'')
    CALL Table.addFieldDefinition("XX-EX.PC.ENT.PER","5","A","")
    CALL Table.addAmountField('XX-EX.PC.ENT.AMT','CURRENCY',Field_AllowNegative,'')
    CALL Table.addAmountField('XX-EX.PC.AMT','CURRENCY',Field_AllowNegative,'')
    CALL Table.addAmountField('XX-EX.PC.AVL.AMT','CURRENCY',Field_AllowNegative,'')
    CALL Table.addFieldDefinition("XX-EX.LC.SHIP.DATE","12","D","")
    CALL Table.addFieldDefinition("XX-XX<LC.REP.BYCONT","40","A","")
    CALL Table.addAmountField('XX-XX>LC.REP.CONT.AMT','CURRENCY',Field_AllowNegative,'')
    CALL Table.addFieldDefinition("XX-XX<EX.BTB.TF.NO","20","A","")
    CALL Field.setCheckFile("LETTER.OF.CREDIT")
    CALL Table.addAmountField('XX-XX>EX.BTB.USE.ENTAMT','CURRENCY',Field_AllowNegative,'')
    CALL Table.addFieldDefinition("XX-XX<EX.PC.NO","20","A","")
    CALL Table.addAmountField('XX-XX>EX.PC.USE.EAMT','CURRENCY',Field_AllowNegative,'')
    CALL Table.addFieldDefinition("XX-XX<EX.DR.ID","20","A","")
    CALL Field.setCheckFile("DRAWINGS")
    CALL Table.addFieldDefinition("XX-XX-EX.DR.CUR","3","A","")
    CALL Table.addAmountField('XX-XX-EX.DR.AMT','CURRENCY',Field_AllowNegative,'')
    CALL Table.addFieldDefinition("XX-XX-EX.PUR.ID","20","A","")
    CALL Table.addFieldDefinition("XX-XX-EX.PUR.FC.CUR","3","A","")
    CALL Table.addAmountField('XX-XX-EX.PUR.AMT.FCY','CURRENCY',Field_AllowNegative,'')
    CALL Table.addFieldDefinition("XX-XX-EX.PUR.EX.RT","7","A","")
    CALL Table.addAmountField('XX-XX>EX.PUR.AMT.LCY','CURRENCY',Field_AllowNegative,'')
    CALL Table.addFieldDefinition("XX>EX.EXPIRY.DATE","12","D","")
*
    CALL Table.addFieldDefinition("XX<IM.TF.REF","20","A","")
    CALL Field.setCheckFile("LETTER.OF.CREDIT")
    CALL Table.addFieldDefinition("XX-IM.ISSUE.DATE","12","D","")
    CALL Table.addFieldDefinition("XX-IM.BB.LC.NO","25","A","")
    CALL Table.addFieldDefinition("XX-IM.LC.CURRENCY","3","A","")
    CALL Table.addAmountField('XX-IM.LC.AMOUNT','CURRENCY',Field_AllowNegative,'')
    CALL Table.addFieldDefinition("XX-XX<IM.BTB.ISS.AG","11","":FM:"EXPORTLC_CONTRACT_REPLACECONT","")
    CALL Table.addFieldDefinition("XX-XX-IM.CONT.TFNO","20","A","")
    CALL Field.setCheckFile("LETTER.OF.CREDIT")
    CALL Table.addFieldDefinition("XX-XX-IM.EXPLC.TFNO","20","A","")
    CALL Field.setCheckFile("LETTER.OF.CREDIT")
    CALL Table.addAmountField('XX-XX>IM.EXPCONT.EAMT','CURRENCY',Field_AllowNegative,'')
    CALL Table.addFieldDefinition("XX-XX<IM.DR.ID","20","A","")
    CALL Field.setCheckFile("DRAWINGS")
    CALL Table.addFieldDefinition("XX-XX-IM.DR.CUR","3","A","")
    CALL Table.addAmountField('XX-XX-IM.DR.AMT','CURRENCY',Field_AllowNegative,'')
    CALL Table.addFieldDefinition("XX-XX-IM.PAD.ID","20","A","")
    CALL Table.addFieldDefinition("XX-XX-IM.PAD.FC.CUR","3","A","")
    CALL Table.addAmountField('XX-XX-IM.PAD.AMT.FCY','CURRENCY',Field_AllowNegative,'')
    CALL Table.addFieldDefinition("XX-XX-IM.PAD.EX.RT","7","A","")
    CALL Table.addAmountField('XX-XX>IM.PAD.AMT.LCY','CURRENCY',Field_AllowNegative,'')
    CALL Table.addFieldDefinition("XX>IM.EXPIRY.DATE","12","D","")
*
    CALL Table.addFieldDefinition("XX<PCECC.LOAN.ID","20","A","")
    CALL Table.addFieldDefinition("XX-LOAN.FC.CUR","3","A","")
    CALL Table.addAmountField('XX-LOAN.AMT.FCY','CURRENCY',Field_AllowNegative,'')
    CALL Table.addFieldDefinition("XX-LOAN.EX.RT","7","A","")
    CALL Table.addAmountField('XX-LOAN.AMT.LCY','CURRENCY',Field_AllowNegative,'')
    CALL Table.addFieldDefinition("XX-XX<LOAN.ISS.AG","11","":FM:"EXPORTLC_CONTRACR_REPLACECONT","")
    CALL Table.addFieldDefinition("XX-XX-LN.CONT.TFNO","20","A","")
    CALL Field.setCheckFile("LETTER.OF.CREDIT")
    CALL Table.addFieldDefinition("XX-XX-LN.EXPLC.TFNO","20","A","")
    CALL Field.setCheckFile("LETTER.OF.CREDIT")
    CALL Table.addAmountField('XX-XX>LN.EXPCONT.EAMT','CURRENCY',Field_AllowNegative,'')
    CALL Table.addFieldDefinition("XX>LOAN.MAT.DT","12","D","")
*
    CALL Table.addField('XX<TF.PARK.ACID',T24_Account,'','')
    CALL Table.addFieldDefinition('XX-TF.PARK.CURR','3','A','')
    CALL Table.addOptionsField('XX-TF.PARK.TYPE','SETTLE_FCHELD','','')
    CALL Table.addAmountField('XX>TF.PARK.OUT.AMT','CURRENCY',Field_AllowNegative,'')
*
    CALL Table.addFieldDefinition("JOB.EXPIRY.DATE","12","D","")
    CALL Table.addAmountField('TOT.EX.LC.AMT','CURRENCY',Field_AllowNegative,'')
    CALL Table.addAmountField('TOT.NET.FOB.VALUE','CURRENCY',Field_AllowNegative,'')
    CALL Table.addAmountField('TOT.PC.ENT.AMT','CURRENCY',Field_AllowNegative,'')
    CALL Table.addAmountField('TOT.PC.AMT','CURRENCY',Field_AllowNegative,'')
    CALL Table.addAmountField('TOT.PC.AVL.AMT','CURRENCY',Field_AllowNegative,'')
    CALL Table.addAmountField('TOT.BTB.ENT.AMT','CURRENCY',Field_AllowNegative,'')
    CALL Table.addAmountField('TOT.BTB.AMT','CURRENCY',Field_AllowNegative,'')
    CALL Table.addAmountField('TOT.BTB.AVL.AMT','CURRENCY',Field_AllowNegative,'')
    CALL Table.addAmountField('TOT.EX.LC.DRAW.AMT','CURRENCY',Field_AllowNegative,'')
    CALL Table.addAmountField('TOT.SHIP.DUE.AMT','CURRENCY',Field_AllowNegative,'')
*
* CHANGE Resrve filed to option field
    CALL Table.addOptionsField('MARK.FOR.REVERSE','YES_NO','','')
*    CALL Table.addReservedField('XX-RESERVED.15')
    CALL Table.addReservedField('XX-RESERVED.14')
    CALL Table.addReservedField('XX-RESERVED.13')
    CALL Table.addReservedField('XX-RESERVED.12')
    CALL Table.addReservedField('XX-RESERVED.11')
    CALL Table.addReservedField('XX-RESERVED.10')
    CALL Table.addReservedField('XX.RESERVED.09')
    CALL Table.addReservedField('XX.RESERVED.08')
    CALL Table.addReservedField('XX.RESERVED.07')
    CALL Table.addReservedField('XX.RESERVED.06')
    CALL Table.addReservedField('XX.RESERVED.05')
    CALL Table.addReservedField('XX.RESERVED.04')
    CALL Table.addReservedField('XX.RESERVED.03')
    CALL Table.addReservedField('XX.RESERVED.02')
    CALL Table.addReservedField('XX.RESERVED.01')
    CALL Table.addField('XX.LOCAL.REF', T24_String, Field_NoInput,'')
    CALL Table.addOverrideField
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
