SUBROUTINE TF.JBL.E.BLD.LCTYPES.CATEG(ENQ.DATA)
*-----------------------------------------------------------------------------
*Subroutine Description:
*Subroutine Type:
*Attached To    : LC.BD.JBL.IMPSIGHT ENQUIRY
*Attached As    : ENQUIRY BUILD ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 22/10/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
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
    ENQ.DATA<2,1> = 'CATEGORY.CODE'
    ENQ.DATA<3,1> = 'EQ'
    ENQ.DATA<4,1> = '23005 23005 23020 23020 23091 23092 23075 23045 23045 23065 23093 23085'
RETURN
*** </region>
END