SUBROUTINE BD.SOC.BALINFO.ID
*-----------------------------------------------------------------------------
*Developer Info:
*    Date         : 20/02/2022
*    Description  : Template BD.SOC.BALINFO
*    Developed By : Md. Tajul Islam
*    Designation  : Software Engineer
*    Email        : tajul.ntl@nazihargroup.com
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
* TODO Add logic to validate the id
* TODO Create an EB.ERROR record if you are creating a new error code
*-----------------------------------------------------------------------------

    IDCAP=EB.SystemTables.getComi()
    

    ID.SHOW=''
    TDATE=EB.SystemTables.getToday()[1,4]
    ID.SHOW=IDCAP:TDATE
    EB.SystemTables.setComi(ID.SHOW)
    
************************************TRACER*********************************
*    WriteData = ''
*    WriteData = ID.SHOW
*
*    FileName = 'template_db_Id.txt'
*    FilePath = 'E:\TRACER\'
*    OPENSEQ FilePath,FileName TO FileOutput THEN NULL
*    ELSE
*        CREATE FileOutput ELSE
*        END
*    END
*    WRITESEQ WriteData TO FileOutput ELSE
*        CLOSESEQ FileOutput
*    END
*    CLOSESEQ FileOutput
*
    
RETURN

END
