SUBROUTINE TF.JBL.E.BLD.TFLCY.AR.PRODUCT.GP(ENQ.DATA)
*-----------------------------------------------------------------------------
*Subroutine Description: This build routine to alter the selection list of category
*Subroutine Type:
*Attached To    : JBL.ENQ.TFAC.AA.PRODUCT.CATALOG.AC
*Attached As    : BUILD ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 04/07/2020 -                            Retrofit   - MD. SHAJJAD HOSSEN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INCLUDE I_ENQUIRY.COMMON

*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.FIELDS=ENQ.DATA<2>
    Y.POS=DCOUNT(Y.FIELDS,@VM)+1
    ENQ.DATA<2,Y.POS>='PRODUCT.GROUP'
    ENQ.DATA<3,Y.POS>='EQ'
    ENQ.DATA<4,Y.POS>='JBL.FCACTAKA.GRP.AC JBL.TFLCY.GRP.AC'
RETURN
*** </region>

END

