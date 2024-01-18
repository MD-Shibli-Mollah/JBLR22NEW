SUBROUTINE TF.JBL.E.BLD.TFFCY.PRODUCT.PRD(ENQ.DATA)
*-----------------------------------------------------------------------------
*Subroutine Description: This build routine to alter the selection list of PRODUCT
*Subroutine Type:
*Attached To    : JBL.ENQ.AA.ARR.TFFCY-NAU
*Attached As    : BUILD ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 12/07/2021 -                            Create   - MD. EBRAHIM KHALIL RIAN
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INCLUDE I_ENQUIRY.COMMON
*-----------------------------------------------------------------------------
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------
  
*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.FIELDS=ENQ.DATA<2>
    Y.POS=DCOUNT(Y.FIELDS,@VM)+1
    ENQ.DATA<2,Y.POS>= "PRODUCT"
    ENQ.DATA<3,Y.POS>= "EQ"
    ENQ.DATA<4,Y.POS>= "JBL.FCDEPGEN.AC JBL.FCDEPNRB.AC JBL.RESFRNDEP.AC JBL.EXPRETQUOTA.AC JBL.LTFFGTFJAICA.AC JBL.AGTBTBLC.AC JBL.EDF.AC JBL.BBREFINANCE.AC"
RETURN
*** </region>

END