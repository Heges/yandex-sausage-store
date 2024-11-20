package com.yandex.practicum.devops.task;

import com.yandex.practicum.devops.model.Report;
import com.yandex.practicum.devops.repository.ReportRepository;
import org.junit.Assert;
import org.junit.Test;
import org.springframework.web.client.RestTemplate;

import java.lang.reflect.Field;

import static org.mockito.Mockito.*;

public class ReportSaverTaskTest {
    ReportRepository reportRepository = mock(ReportRepository.class);

    ReportSaverTask reportSaverTask = new ReportSaverTask(reportRepository);

    @Test
    public void saveReport() throws Exception {
        // Given
        Field field = ReportSaverTask.class.getDeclaredField("restTemplate");
        field.setAccessible(true);
        RestTemplate restTemplate = mock(RestTemplate.class);
        field.set(reportSaverTask, restTemplate);

        Report report = new Report();
        when(restTemplate.getForObject(anyString(), any())).thenReturn(report);

        // When
        reportSaverTask.saveReport();

        // Then
        verify(reportRepository, times(1)).save(report);
    }
}
