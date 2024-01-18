*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE EB.BD.EXCISE.DUTY.LD
*-----------------------------------------------------------------------------
*Subroutine Description:
*-----------------------
* This table is used to store Pre mature LD details
*-------------------------------------------------------------------------
* Project Name : Janatha Bank Limited(Bangladesh)
*-------------------------------------------------------------------------
* Modification History :
*-----------------------
* 28/04/11                      -  Chethana.H.N.
* ----------------------------------------------------------------------------
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_Table
*-----------------------------------------------------------------------------
    Table.name = 'EB.BD.EXCISE.DUTY.LD'        ;* Full application name including product prefix
    Table.title ='EB.BD.EXCISE.DUTY.LD'       ;* Screen title
    Table.stereotype = 'T'    ;* H, U, L, W or T
    Table.product = 'EB'      ;* Must be on EB.PRODUCT
    Table.subProduct = ''     ;* Must be on EB.SUB.PRODUCT
    Table.classification = 'FIN'        ;* As per FILE.CONTROL
    Table.systemClearFile = 'Y'         ;* As per FILE.CONTROL
    Table.relatedFiles = ''   ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''        ;* As per FILE.CONTROL
    Table.equatePrefix = 'LD.EXC'        ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix = ''       ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = ''         ;* Space delimeted list of blocked functions
    Table.trigger = ''        ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

    RETURN
END
