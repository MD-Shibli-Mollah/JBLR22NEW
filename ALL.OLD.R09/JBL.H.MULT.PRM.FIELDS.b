*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE JBL.H.MULT.PRM.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine JBL.H.MULT.PRM.FIELDS
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
    CALL Table.defineId("TRH.ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------
    CALL Table.addFieldDefinition("SUS.CATEG", "5", "", "")
    CALL Field.setCheckFile('CATEGORY')        ;* Use DEFAULT.ENRICH from SS or just field 1
    CALL Table.addFieldDefinition("XX.OVERDRAFT.RES.CATEG", "5", "", "")
    CALL Field.setCheckFile('CATEGORY')        ;* Use DEFAULT.ENRICH from SS or just field 1
    CALL Table.addFieldDefinition("XX.ORDERING.BANK", "15", "", "")
    CALL Table.addFieldDefinition("XX.PROFIT.CENTRE.DEPT", "15", "", "")
    CALL Table.addFieldDefinition("XX.LOCAL.REF", "35", "", "")
    CALL Table.addFieldDefinition("XX.LIMIT.CHK.CATEG", "5", "", "")
    CALL Table.addReservedField('RESERVED.05')
    CALL Table.addReservedField('RESERVED.04')
    CALL Table.addReservedField('RESERVED.03')
    CALL Table.addReservedField('RESERVED.02')
    CALL Table.addReservedField('RESERVED.01')
    CALL Table.addOverrideField
    
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
