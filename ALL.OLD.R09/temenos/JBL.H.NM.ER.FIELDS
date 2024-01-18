*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE JBL.H.NM.ER.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine JBL.H.NM.ER.FIELDS
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
*    CALL Table.defineId("TABLE.NAME.ID", T24_String) ;* Define Table id
    ID.F = "REF.ID" ; ID.N = "20" ; ID.T = "A"
*-----------------------------------------------------------------------------
    CALL Table.addFieldDefinition('BRANCH.CODE','15','A','')
    CALL Table.addFieldDefinition("VALUE.DATE","8","D":FM:"":FM:"NOINPUT","")
    CALL Table.addFieldDefinition("OE.RE","3","":FM:"ORG_RES","")
    CALL Table.addFieldDefinition('TRANS.CODE','4','A','')
    CALL Field.setCheckFile('JBL.H.NGMO.TR')
    CALL Table.addFieldDefinition("DATE.OF.OE","8","D","")
    CALL Table.addFieldDefinition("ADVICE.NO","35","A","")
    CALL Table.addFieldDefinition("SUB.ADVICE.NO","35","A","")
    CALL Table.addFieldDefinition("TRANSACTION.TYPE","35","A","")
    CALL Table.addFieldDefinition("DR.CR.MARKER","2","":FM:"DR_CR","")
    CALL Table.addFieldDefinition("ACCOUNT.NO","25","A","")
    CALL Table.addFieldDefinition("NAME","25","A","")
    CALL Table.addFieldDefinition("CHQ.NO","10","A","")
    CALL Table.addFieldDefinition("AMOUNT","19","AMT":FM:"":FM:"NOINPUT","")
    CALL Table.addFieldDefinition("REMARKS","35","A","")
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
