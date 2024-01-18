* @ValidationCode : MjotODI5MDQyNDI5OkNwMTI1MjoxNTI0NzI1MTY0MjgzOkFkbWluaXN0cmF0b3I6LTE6LTE6MDowOnRydWU6Ti9BOlIxN19BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Apr 2018 12:46:04
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Administrator
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
SUBROUTINE BD.LC.MARGIN.BAL.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine BD.LC.MARGIN.BAL.FIELDS
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
*CALL Table.defineId("TABLE.NAME.ID", T24_String) ;* Define Table id
    ID.F = "TF.NUMBER" ;  ID.N = "35" ; ID.T = "A" ; ID.CHECKFILE = "LETTER.OF.CREDIT" ;
*-----------------------------------------------------------------------------
*CALL Table.addField(fieldName, fieldType, args, neighbour) ;* Add a new fields
*CALL Field.setCheckFile(fileName)        ;* Use DEFAULT.ENRICH from SS or just field 1
*CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
*CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour) ;* Specify Lookup values
*CALL Field.setDefault(defaultValue) ;* Assign default value
    
    CALL Table.addFieldDefinition("XX<DR.NUMBER", "35.1", "A", "")
    CALL Table.addFieldDefinition("XX-XX<DR.PROV.ORG.OUT.AMT", "35.1", "AMT", "")
    CALL Table.addFieldDefinition("XX-XX-DR.PROV.INC.AMT", "35.1", "AMT", "")
    CALL Table.addFieldDefinition("XX-XX-DATE", "12.1", "D", "")
    CALL Table.addFieldDefinition("XX>XX>TIME", "12.1", "A", "")
    
    CALL Table.addReservedField('RESERVED.05')
    CALL Table.addReservedField('RESERVED.04')
    CALL Table.addReservedField('RESERVED.03')
    CALL Table.addReservedField('RESERVED.02')
    CALL Table.addReservedField('RESERVED.01')
    
    CALL Table.addField('XX.LOCAL.REF', T24_String, Field_NoInput,'')
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END