*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE BD.FT.STUDENTFILE.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine BD.FT.STUDENTFILE.FIELDS
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
    CALL Table.defineId("STUDENT.ID", T24_Customer) ;* Define Table id
    ID.CHECKFILE ='CUSTOMER'
*-----------------------------------------------------------------------------
    CALL Table.addFieldDefinition("CUSTOMER.MNEMONIC", "10", "MNE", "")
    CALL Table.addFieldDefinition("STUDENT.NAME", "35", "A", "")
    CALL Table.addFieldDefinition("COURSE.NAME", "35", "":FM:"SCHOOL LEVEL_UNDER GRADUATE_GRADUATE_LANGUAGE COURSE_PRE REQUISITE FOUNDATION_CERTIFICATION COURSE_PROFESSIONAL DIPLAMA", "")
    CALL Table.addFieldDefinition("BB.PERMISSION.NO", "20", "A", "")
    CALL Table.addFieldDefinition("BB.PERMISSION.DATE", "12", "D", "")
    CALL Table.addField("BRANCH.CODE", T24_String, "", "")
    CALL Field.setCheckFile('COMPANY')
    CALL Table.addField("ACCOUNT.NUMBER", T24_Account, "", "")
    CALL Table.addFieldDefinition("FT.STATUS", "35", "A", "")
    CALL Table.addFieldDefinition("XX<FT.TXN.REF","35","A","")
    CALL Table.addFieldDefinition("XX-REM.DATE","12","D","")
    CALL Table.addFieldDefinition("XX-REM.AMOUNT","19","AMT","")
    CALL Table.addFieldDefinition("XX-CURR.TYPE","3","CCY","")
    CALL Table.addFieldDefinition("XX-FDD.NUMBER","35","A","")
    CALL Table.addFieldDefinition("XX>PURP.OF.TRAN","35","A","")
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
