*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE BD.LC.SERIAL.NUMBER.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine BD.LC.SERIAL.NUMBER.FIELDS
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
    ID.F = "BD.SERIAL.ID" ; ID.N = "4" ; ID.T = ""
*-----------------------------------------------------------------------------
    CALL Table.addFieldDefinition("XX<BRANCH.CODE","4","A","")
    CALL Table.addFieldDefinition("XX-XX<LC.TYPE.CODE","2","A","")
    CALL Table.addFieldDefinition("XX>XX>LC.SEQ.NO","5","A","")
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
